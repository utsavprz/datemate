import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Interests extends StatefulWidget {
  final String? interest;

  Interests(this.interest, {Key? key}) : super(key: key);

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  List<String> currentUserInterest = [];

  @override
  void initState() {
    super.initState();
    fetchCurrentUserInterest();
  }

  Future<void> fetchCurrentUserInterest() async {
    try {
      currentUserInterest = await getCurrentUserInterest();
      setState(() {}); // Refresh the widget after fetching the interest
    } catch (error) {
      print('Error fetching user interest: $error');
    }
  }

  Future<List<String>> getCurrentUserInterest() async {
    final String? userId = FirebaseAuth.instance.currentUser!.uid;

    if (userId != null) {
      try {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('userProfile')
                .doc(userId)
                .get();

        if (snapshot.exists) {
          final interests = snapshot.get('interest');
          if (interests is List) {
            return interests.map((interest) => interest.toString()).toList();
          }
        }
      } catch (error) {
        print('Error fetching user interests: $error');
      }
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: currentUserInterest.contains(widget.interest)
                  ? Colors.red
                  : Colors.grey),
        ),
        child: Text(
          widget.interest!,
          style: TextStyle(
              fontSize: 14,
              color: currentUserInterest.contains(widget.interest)
                  ? Colors.red
                  : Colors.grey),
        ),
      ),
    );
  }
}
