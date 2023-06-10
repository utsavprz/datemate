import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';

final userProvider = ChangeNotifierProvider<UserProvider>((ref) {
  return UserProvider();
});

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void updateUser({
    String? id,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? phoneNumber,
    String? gender,
    File? imageFile,
    String? image,
    List<String>? interest,
  }) {
    _user = UserModel(
      id: _user?.id,
      userId: _user?.userId,
      firstName: firstName ?? _user?.firstName,
      lastName: lastName ?? _user?.lastName,
      birthday: birthday ?? _user?.birthday,
      phoneNumber: phoneNumber ?? _user?.phoneNumber,
      gender: gender ?? _user?.gender,
      imageFile: imageFile ?? _user?.imageFile,
      image: image ?? _user?.image,
      interest: interest ?? _user?.interest,
    );
    notifyListeners();
  }
Future<void> uploadUserDataToFirebase() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (_user == null || userId == null) {
      return;
    }

    final userDocRef =
        FirebaseFirestore.instance.collection('userProfile').doc(userId);

    // Remove imageFile from _user
    final updatedUser = UserModel(

      userId: userId,
      firstName: _user?.firstName,
      lastName: _user?.lastName,
      birthday: _user?.birthday,
      phoneNumber: _user?.phoneNumber,
      gender: _user?.gender,
      image: _user?.image,
      interest: _user?.interest,
    );

    final userData = updatedUser.toJson() as Map<String, dynamic>;

    await userDocRef.set(userData);
  } catch (error) {
    print('Error uploading user data to Firebase: $error');
  }
}

}
