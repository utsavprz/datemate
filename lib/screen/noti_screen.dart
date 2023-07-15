import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatefulWidget {
  static const String route = 'NotificationScreen';
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Stream<List<NotificationModel>> fetchNotifications() {
    final currentUser = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: currentUser!.uid)
        .orderBy('time', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => NotificationModel.fromSnapshot(doc))
            .toList());
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .update({'read': true});

    // Refresh the notifications after marking as read
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding:
            const EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Color.fromARGB(255, 212, 212, 212))),
                    child: IconButton(
                      splashRadius: 1,
                      icon: Icon(
                        Icons.chevron_left_sharp,
                        color: Color.fromARGB(255, 215, 78, 91),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'SKModernistBold',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<NotificationModel>>(
                stream: fetchNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final notifications = snapshot.data!;
                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(notification.userImage),
                          ),
                          title: Text(notification.userName),
                          subtitle: Text(notification.message),
                          trailing: Text(notification.time),
                          onTap: () {
                            markNotificationAsRead(notification.notificationId);
                            // Handle notification tap
                            // Implement your logic to navigate to the relevant page
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return Text('No Notification');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class NotificationModel {
  final String notificationId;
  final String userName;
  final String userImage;
  final String message;
  final String time;

  NotificationModel({
    required this.notificationId,
    required this.userName,
    required this.userImage,
    required this.message,
    required this.time,
  });

  factory NotificationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return NotificationModel(
      notificationId: snapshot.id,
      userName: data['userName'],
      userImage: data['userImage'],
      message: data['message'],
      time: data['time'],
    );
  }
}
