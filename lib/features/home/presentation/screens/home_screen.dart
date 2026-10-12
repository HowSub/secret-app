import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secret/features/home/presentation/widgets/home_chat_list.dart';
import 'package:secret/features/home/presentation/widgets/home_search_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final username = FirebaseAuth.instance.currentUser?.displayName ?? 'User';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.push('/profile');
          },
          icon: CircleAvatar(
            backgroundColor: Colors.black,
            child: Text(username[0], style: TextStyle(color: Colors.white)),
          ),
        ),
        title: Row(
          children: [
            Text('Secret', style: TextStyle(fontWeight: .w600, fontSize: 24)),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              HomeSearchField(),
              const SizedBox(height: 20),
              HomeChatList(),
            ],
          ),
        ),
      ),
    );
  }
}
