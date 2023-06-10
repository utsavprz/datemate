// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

class UserModel {
  final String? id;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final DateTime? birthday;
  final String? phoneNumber;
  final String? gender;
  final File? imageFile;
  final String? image;
  final List<String>? interest;

  const UserModel({
    this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.phoneNumber,
    required this.gender,
    this.imageFile,
    this.image,
    required this.interest,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday?.millisecondsSinceEpoch,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'imageFile': imageFile,
      'image': image,
      'interest': interest,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday?.toIso8601String(),
      'phoneNumber': phoneNumber,
      'gender': gender,
      'image': image,
      'interest': interest,
    };
  }
}
