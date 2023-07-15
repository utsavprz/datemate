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
    List<String>? images,
    double? lat,
    double? lon,
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
      images: images ?? _user?.images,
      lat: lat ?? _user?.lat,
      lon: lon ?? _user?.lon,
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
        images: _user?.images,
      );

      final userData = updatedUser.toJson() as Map<String, dynamic>;

      await userDocRef.set(userData);
    } catch (error) {
      print('Error uploading user data to Firebase: $error');
    }
  }

  Future<void> updateUserDataToFirebase({
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? phoneNumber,
    String? gender,
    String? image,
    List<String>? interest,
    List<String>? images,
    double? lat,
    double? lon,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;

      final userDocRef =
          FirebaseFirestore.instance.collection('userProfile').doc(userId);

      final updatedUser = UserModel(
        userId: userId,
        firstName: firstName ?? _user?.firstName,
        lastName: lastName ?? _user?.lastName,
        birthday: birthday ?? _user?.birthday,
        phoneNumber: phoneNumber ?? _user?.phoneNumber,
        gender: gender ?? _user?.gender,
        image: image ?? _user?.image,
        interest: interest ?? _user?.interest,
        images: images ?? _user?.images,
        lat: lat ?? _user?.lat,
        lon: lon ?? _user?.lon,
      );

      final userData = updatedUser.toJson() as Map<String, dynamic>;

      await userDocRef.update(userData);
    } catch (error) {
      print('Error updating user data in Firebase: $error');
    }
  }

  Future<void> fetchUserDataFromFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;

      if (userId == null) {
        return;
      }

      final userDocRef =
          FirebaseFirestore.instance.collection('userProfile').doc(userId);

      final userData = await userDocRef.get();
      if (userData.exists) {
        final data = userData.data() as Map<String, dynamic>;
        final userModel = UserModel.fromJson(data);
        updateUser(
          id: userModel.id,
          firstName: userModel.firstName,
          lastName: userModel.lastName,
          birthday: userModel.birthday,
          phoneNumber: userModel.phoneNumber,
          gender: userModel.gender,
          image: userModel.image,
          images: userModel.images,
          interest: userModel.interest,
          lat: userModel.lat,
          lon: userModel.lon,
        );
      }
    } catch (error) {
      print('Error fetching user data from Firebase: $error');
    }
  }
}
