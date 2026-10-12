import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeSearchField extends StatefulWidget {
  const HomeSearchField({super.key});

  @override
  State<HomeSearchField> createState() => _HomeSearchFieldState();
}

class _HomeSearchFieldState extends State<HomeSearchField> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, String>> _searchResults = [];

  Timer? _debounce;

  void _onChangeText(String query) {
    final query = _controller.text.trim().toLowerCase().replaceAll('@', '');

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    if (query.length < 3) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchUsers(query);
    });
  }

  void _searchUsers(String query) async {
    final db = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://post-auth-42085-default-rtdb.europe-west1.firebasedatabase.app',
    );

    final snapshot = await db
        .ref('usernames')
        .orderByKey()
        .startAt(query)
        .endAt('$query\uf8ff')
        .get()
        .timeout(const Duration(seconds: 4));

    if (snapshot.exists && snapshot.value != null) {
      final usernamesMap = Map<String, dynamic>.from(snapshot.value as Map);
      final List<Map<String, String>> tempResults = [];

      for (var entry in usernamesMap.entries) {
        final username = entry.key;
        final uid = entry.value as String;

        if (uid == FirebaseAuth.instance.currentUser?.uid) continue;

        final userSnapshot = await db.ref('users/$uid').get();
        if (userSnapshot.exists && userSnapshot.value != null) {
          final userData = Map<String, dynamic>.from(userSnapshot.value as Map);
          tempResults.add({
            'uid': uid,
            'username': userData['username'] ?? username,
            'name': userData['name'] ?? 'User',
          });
        }
      }
      setState(() {
        _searchResults = tempResults;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: _controller,
            onChanged: _onChangeText,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0x64EBEBEB),
              prefixIcon: Icon(Icons.search),
              hintText: 'Search...',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
        if (_searchResults.isNotEmpty)
          Container(
            height: 100,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final user = _searchResults[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text(
                      user['name']![0],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(user['name']!),
                  subtitle: Text('@${user['username']}'),
                  onTap: () {
                    final myUid = FirebaseAuth.instance.currentUser?.uid;
                    final partnerUid = user['uid'];
                    final partnerName = user['name'];

                    if (myUid == null ||
                        partnerUid == null ||
                        partnerName == null)
                      return;

                    final List<String> uids = [myUid, partnerUid];
                    uids.sort();
                    final chatRoomId = uids.join('_');
                    setState(() {
                      _searchResults = [];
                      _controller.clear();
                    });

                    context.push('/chat/$chatRoomId/$partnerName/$partnerUid');
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
