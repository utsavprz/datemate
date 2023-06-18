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
  final double? lat;
  final double? lon;

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
    this.lat,
    this.lon,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthday:
          json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      image: json['image'],
      lat: json['lat'],
      lon: json['lon'],
      interest: List<String>.from(json['interest'] ?? []),
    );
  }

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
      'lat': lat,
      'lon': lon,
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
      'lat': lat,
      'lon': lon,
    };
  }
}
