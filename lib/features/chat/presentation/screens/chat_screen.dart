import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:secret/features/chat/domain/repositories/chat_repository.dart';
import 'package:secret/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:secret/features/chat/presentation/bloc/chat_event.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final DatabaseReference _ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://post-auth-42085-default-rtdb.europe-west1.firebasedatabase.app',
  ).ref('messages/chat_room_1');

  final TextEditingController _sendController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isNearBottom = true;
  int _unreadCount = 0;

  bool isHaveMessages = false;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    _ref.onChildAdded.listen((event) {
      if (!_isNearBottom) {
        setState(() {
          _unreadCount++;
        });
      } else {
        _scrollToBottom();
      }
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _scrollToBottom();
      }
    });

    _sendController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll - currentScroll < 50) {
      if (!_isNearBottom) {
        setState(() {
          _isNearBottom = true;
          _unreadCount = 0;
        });
      }
    } else {
      if (_isNearBottom) {
        setState(() {
          _isNearBottom = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _sendController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Chat', style: TextStyle(fontSize: 24, fontWeight: .w600)),
      ),
      body: BlocProvider(
        create: (_) => ChatBloc(GetIt.I<ChatRepository>()),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: FirebaseAnimatedList(
                  controller: _scrollController,
                  query: _ref,
                  padding: EdgeInsets.only(bottom: 30),
                  itemBuilder: (context, snapshot, animation, index) {
                    final message = Map<String, dynamic>.from(
                      snapshot.value as Map,
                    );
                    final text = message['text'] ?? '';
                    final isMe =
                        message['senderId'] ==
                        FirebaseAuth.instance.currentUser?.uid;

                    return SizeTransition(
                      sizeFactor: animation,
                      child: Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color(0x2F2195F3)
                                : const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(text, style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _sendController,
                        decoration: InputDecoration(
                          hintText: 'Enter message...',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Builder(
                      builder: (newContext) {
                        final bool isCanSend = _sendController.text
                            .trim()
                            .isNotEmpty;
                        return IconButton(
                          onPressed: isCanSend
                              ? () {
                                  if (_sendController.text.trim().isEmpty) {
                                    return null;
                                  }
                                  final _senderId =
                                      FirebaseAuth.instance.currentUser?.uid
                                          as String;
                                  final _text = _sendController.text;

                                  newContext.read<ChatBloc>().add(
                                    SendMessage(
                                      senderId: _senderId,
                                      text: _text,
                                    ),
                                  );

                                  _sendController.clear();
                                }
                              : null,
                          icon: Icon(
                            Icons.send,
                            color: isCanSend
                                ? Colors.black
                                : const Color(0xFFC3C3C3),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
