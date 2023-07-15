import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datemate/models/user_model.dart';
import 'package:datemate/screen/user_detail_screen.dart';
import 'package:datemate/statemanagement/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final UserModel user;
  Function close;

  ChatScreen({required this.user, required this.close});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  TextEditingController _textEditingController = TextEditingController();
  CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromARGB(255, 212, 212, 212),
                ),
              ),
              child: IconButton(
                splashRadius: 1,
                icon: Icon(
                  Icons.close,
                  color: Color.fromARGB(255, 215, 78, 91),
                ),
                onPressed: () {
                  widget.close();
                },
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, UserDetailScreen.route,
                          arguments: widget.user);
                    },
                    child: Container(
                      width: 65,
                      height: 65,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.user.image!),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.user!.image!),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('messages')
              .where('sender', whereIn: [
                FirebaseAuth.instance.currentUser!.uid,
                widget.user.userId
              ])
              .orderBy('timestamp')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Message> messages = [];
            if (snapshot.hasData) {
              final data = snapshot.data!;
              messages = data.docs.map((doc) {
                final docData = doc.data();
                return Message.fromJson(docData);
              }).toList();
            }

            return ListView.builder(
              reverse: false,
              itemCount: messages.length,
              // Show the latest messages at the bottom
              itemBuilder: (context, index) {
                Message message = messages[index];
                bool isSentByCurrentUser = message.sender == currentUserId;
                bool isSentToCurrentUser = message.receiver == currentUserId;
                String senderName =
                    isSentByCurrentUser ? 'You' : widget.user.firstName ?? '';

                // Format the timestamp
                DateTime dateTime = message.timestamp.toDate();

                String formattedTime = DateFormat.jm().format(dateTime);

                String formattedDate =
                    DateFormat.yMMMd().format(message.timestamp.toDate());
                bool isToday = DateTime.now()
                        .difference(message.timestamp.toDate())
                        .inDays ==
                    0;
                if (isToday) {
                  formattedDate = 'Today';
                }

                return Align(
                  alignment: isSentByCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: IntrinsicWidth(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: isSentByCurrentUser
                            ? Color.fromARGB(255, 128, 43, 131)
                            : Color.fromARGB(255, 177, 79, 181),
                      ),
                      child: Column(
                        crossAxisAlignment: isSentByCurrentUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            senderName,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            message.content,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 4.0),
                          Row(
                            mainAxisAlignment: isSentByCurrentUser
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  sendMessage();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void sendMessage() async {
    String content = _textEditingController.text;
    if (content.isNotEmpty) {
      String senderId = FirebaseAuth.instance.currentUser!.uid;
      String receiverId = widget.user.userId!;

      Message message = Message(
        content: content,
        sender: senderId,
        receiver: receiverId,
        timestamp: Timestamp.now(),
      );

      await _messagesCollection.add(message.toJson());

      _textEditingController.clear();
    }
  }
}

class Message {
  final String content;
  final String sender;
  final String receiver;
  final Timestamp timestamp;

  Message({
    required this.content,
    required this.sender,
    required this.receiver,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      sender: json['sender'],
      receiver: json['receiver'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'sender': sender,
      'receiver': receiver,
      'timestamp': timestamp,
    };
  }
}
