import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeChatList extends StatefulWidget {
  const HomeChatList({super.key});

  @override
  State<HomeChatList> createState() => _HomeChatListState();
}

class _HomeChatListState extends State<HomeChatList> {
  final DatabaseReference _userChatsRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://post-auth-42085-default-rtdb.europe-west1.firebasedatabase.app',
  ).ref('user_chats/${FirebaseAuth.instance.currentUser?.uid}');

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      query: _userChatsRef,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, snapshot, animation, index) {
        final chat = Map<String, dynamic>.from(snapshot.value as Map);

        final partnerName = chat['partnerName'] ?? 'User';
        final lastMessage = chat['lastMessage'] ?? '';
        final chatRoomId = chat['chatRoomId'] ?? '';
        final partnerId = chat['partnerId'] ?? '';

        return SizeTransition(
          sizeFactor: animation,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            child: Material(
              color: const Color(0x64EBEBEB),
              borderRadius: BorderRadius.circular(15),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Text(
                    partnerName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  partnerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16,
                ),
                onTap: () {
                  context.push('/chat/$chatRoomId/$partnerName/$partnerId');
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
