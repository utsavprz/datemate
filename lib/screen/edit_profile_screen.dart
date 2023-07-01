import 'dart:io';

import 'package:datemate/screen/NavScreens/account_screen.dart';
import 'package:datemate/statemanagement/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  static const String route = 'EditProfileScreen';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  List<File> _selectedImages = [];
  List<String>? _userImages;
  String? pp;
  bool _isUploadingImages = false;
  bool _changingpp = false;

  bool _fetching = false;

  @override
  void initState() {
    super.initState();
    userProfile();
  }

  userProfile() async {
    await fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    setState(() {
      _fetching = true;
    });
    final String? userId = FirebaseAuth.instance.currentUser!.uid;

    if (userId != null) {
      try {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('userProfile')
                .doc(userId)
                .get();

        if (snapshot.exists) {
          setState(() {
            _firstNameController.text = snapshot.get('firstName');
            _lastNameController.text = snapshot.get('lastName');
            _birthdayController.text = snapshot.get('birthday');
            _phoneNumberController.text = snapshot.get('phoneNumber') ?? '';
            _userImages = List<String>.from(snapshot.get('images') ?? []);
            pp = snapshot.get('image');
          });
        }
      } catch (error) {
        print('Error fetching user profile: $error');
      }
    }
    setState(() {
      _fetching = false;
    });
  }

  Future<void> updateUserProfile() async {
    final String? userId = FirebaseAuth.instance.currentUser!.uid;

    if (userId != null) {
      try {
        setState(() {
          _isUploadingImages = true;
        });

        await FirebaseFirestore.instance
            .collection('userProfile')
            .doc(userId)
            .update({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'birthday': _birthdayController.text,
          'phoneNumber': _phoneNumberController.text,
        });
        print('User profile updated successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        print('Error updating user profile: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isUploadingImages = false;
        });
      }
    }
  }

  Future<void> uploadImages() async {
    final String? userId = FirebaseAuth.instance.currentUser!.uid;

    if (_selectedImages.length + _userImages!.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Images cannot exceed more than 5'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (userId != null) {
      try {
        setState(() {
          _isUploadingImages = true;
        });

        if (_selectedImages.isEmpty) {
          return; // No new images to upload
        }

        if (_userImages == null) {
          _userImages = []; // Initialize the array if it's null
        }

        int remainingSlots = 5 -
            _userImages!.length; // Calculate the remaining slots in the array

        List<String> imageUrls = []; // List to store the image URLs

        for (int i = 0; i < _selectedImages.length && i < remainingSlots; i++) {
          File imageFile = _selectedImages[i];
          String imageName =
              'image_${userId}_${DateTime.now().millisecondsSinceEpoch}';
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child('images/$imageName');
          await ref.putFile(imageFile);
          String imageUrl = await ref.getDownloadURL();
          imageUrls.add(imageUrl); // Add the URL to the list
          print('Image uploaded successfully. URL: $imageUrl');
        }

        // Append the new image URLs to the existing array
        _userImages!.addAll(imageUrls);

        // Keep only the first 5 images in the array
        if (_userImages!.length > 5) {
          _userImages = _userImages!.sublist(0, 5);
        }

        // Update the user profile with the updated image URLs
        await FirebaseFirestore.instance
            .collection('userProfile')
            .doc(userId)
            .update({
          'images': _userImages,
        });

        print('Image URLs stored in userProfile successfully.');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Images uploaded successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh user images
        setState(() {
          _selectedImages = [];
        });
      } catch (error) {
        print('Error uploading images: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload images.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isUploadingImages = false;
        });
      }
    }
  }

  Future<void> removeUserImage(int index) async {
    final String? userId = FirebaseAuth.instance.currentUser!.uid;

    if (userId != null && _userImages != null && index < _userImages!.length) {
      try {
        setState(() {
          _isUploadingImages = true;
        });

        // Remove the image URL from the list
        String imageUrl = _userImages![index];
        _userImages!.removeAt(index);

        // Delete the image file from Firebase Storage
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
        await ref.delete();
        print('Image deleted successfully. URL: $imageUrl');

        // Update the user profile in Firestore
        await FirebaseFirestore.instance
            .collection('userProfile')
            .doc(userId)
            .update({
          'images': _userImages,
        });

        print('Image URL removed from userProfile successfully.');

        // Refresh user images
        setState(() {});
      } catch (error) {
        print('Error removing user image: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove image.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isUploadingImages = false;
        });
      }
    }
  }

  Future<void> pickImages() async {
    print('picking');
    if (_selectedImages.length + _userImages!.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Images cannot exceed more than 5'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    List<XFile>? pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _selectedImages =
            pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
      });
    }
  }

  Future<void> changeProfilePicture() async {
    final user = ref.read(userProvider);
    setState(() {
      _changingpp = true;
    });
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final File imageFile = File(pickedImage.path);

      // Upload the new profile picture to Firebase Storage
      try {
        final String userId = FirebaseAuth.instance.currentUser!.uid;
        final String imageName = 'profile_picture_$userId';
        final firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('profile_pictures/$imageName');
        await ref.putFile(imageFile);
        final String imageUrl = await ref.getDownloadURL();

        // Update the profile picture URL in Firestore
        await FirebaseFirestore.instance
            .collection('userProfile')
            .doc(userId)
            .update({
          'image': imageUrl,
        });

        setState(() {
          pp = imageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture changed successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _changingpp = false;
        });
        user.updateUser(image: imageUrl);
      } catch (error) {
        print('Error changing profile picture: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change profile picture.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _fetching == false
              ? SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                build(context);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 218, 86, 86),
                                  ),
                                ),
                                child: Icon(
                                  Icons.chevron_left_sharp,
                                  color: Color.fromARGB(255, 218, 86, 86),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _changingpp == true
                            ? CircularProgressIndicator()
                            : Stack(children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 100.0,
                                  backgroundImage: _userImages != null &&
                                          _userImages!.isNotEmpty
                                      ? NetworkImage(pp!)
                                      : null,
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: IconButton(
                                          onPressed: () {
                                            changeProfilePicture();
                                          },
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                          )),
                                    ))
                              ]),
                        SizedBox(height: 16.0),
                        TextField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                          ),
                        ),
                        TextField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                          ),
                        ),
                        TextField(
                          controller: _birthdayController,
                          decoration: InputDecoration(
                            labelText: 'Birthday',
                          ),
                        ),
                        TextField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            updateUserProfile();
                          },
                          child: Text('Save Profile'),
                        ),
                        SizedBox(height: 16.0),
                        SizedBox(height: 8.0),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: [
                            ..._userImages!.map(
                              (imageUrl) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Stack(
                                  children: [
                                    Image.network(imageUrl),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          int index =
                                              _userImages!.indexOf(imageUrl);
                                          removeUserImage(index);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.close, size: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ..._selectedImages.map(
                              (image) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Stack(
                                  children: [
                                    Image.file(image),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImages.remove(image);
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.close, size: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                child: IconButton(
                              onPressed: () {
                                pickImages();
                              },
                              icon: Icon(Icons.add),
                            ))
                          ],
                        ),
                        SizedBox(height: 16.0),
                        if (_isUploadingImages)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: Column(
                              children: [
                                CircularProgressIndicator(),
                                Text('Please wait....')
                              ],
                            )),
                          ),
                        ElevatedButton(
                          onPressed: () {
                            uploadImages();
                          },
                          child: Text('Upload Images'),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
