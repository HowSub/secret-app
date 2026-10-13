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
  final String chatRoomId;
  final String partnerName;
  final String partnerId;

  const ChatScreen({
    super.key,
    required this.chatRoomId,
    required this.partnerName,
    required this.partnerId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final DatabaseReference _ref;
  late final DatabaseReference _refMyChat;
  late final DatabaseReference _refSecondChat;

  final TextEditingController _sendController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL:
          'https://post-auth-42085-default-rtdb.europe-west1.firebasedatabase.app',
    ).ref('chats/${widget.chatRoomId}');

    _refMyChat =
        FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              'https://post-auth-42085-default-rtdb.europe-west1.firebasedatabase.app',
        ).ref(
          'user_chats/${FirebaseAuth.instance.currentUser?.uid}/${widget.partnerId}',
        );

    _refSecondChat =
        FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              'https://post-auth-42085-default-rtdb.europe-west1.firebasedatabase.app',
        ).ref(
          'user_chats/${widget.partnerId}/${FirebaseAuth.instance.currentUser?.uid}',
        );

    _sendController.addListener(() {
      setState(() {});
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
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.black,
              child: Text(
                widget.partnerName[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text(widget.partnerName, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
      body: BlocProvider(
        create: (_) => ChatBloc(GetIt.I<ChatRepository>()),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: FirebaseAnimatedList(
                  controller: _scrollController,
                  sort: (DataSnapshot a, DataSnapshot b) {
                    final aMap = Map<String, dynamic>.from(a.value as Map);
                    final bMap = Map<String, dynamic>.from(b.value as Map);

                    final aTimestamp = aMap['timestamp'] as int? ?? 0;
                    final bTimestamp = bMap['timestamp'] as int? ?? 0;

                    return bTimestamp.compareTo(aTimestamp);
                  },
                  query: _ref.orderByChild('timestamp'),
                  reverse: true,
                  padding: const EdgeInsets.only(top: 30),
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
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color(0xFF000000)
                                : const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            text,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
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
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
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
                                  final myUid =
                                      FirebaseAuth.instance.currentUser?.uid
                                          as String;
                                  final myName =
                                      FirebaseAuth
                                          .instance
                                          .currentUser
                                          ?.displayName ??
                                      'User';
                                  final text = _sendController.text.trim();

                                  // Примечание: При отправке сообщения в узлы чата
                                  // обязательно добавляйте 'timestamp': ServerValue.timestamp,
                                  // чтобы orderByChild('timestamp') работал корректно.
                                  _refMyChat.set({
                                    'chatRoomId': widget.chatRoomId,
                                    'partnerId': widget.partnerId,
                                    'partnerName': widget.partnerName,
                                    'lastMessage': text,
                                    'timestamp': ServerValue.timestamp,
                                  });

                                  _refSecondChat.set({
                                    'chatRoomId': widget.chatRoomId,
                                    'partnerId': myUid,
                                    'partnerName': myName,
                                    'lastMessage': text,
                                    'timestamp': ServerValue.timestamp,
                                  });

                                  newContext.read<ChatBloc>().add(
                                    SendMessage(
                                      chatRoomId: widget.chatRoomId,
                                      senderId: myUid,
                                      text: text,
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
