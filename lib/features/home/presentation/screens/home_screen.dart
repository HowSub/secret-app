import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0x64EBEBEB),
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search...',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 30,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x64EBEBEB),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Chat',
                                style: TextStyle(
                                  fontWeight: .w500,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                      ),
                      onTap: () {
                        context.push('/chat');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
