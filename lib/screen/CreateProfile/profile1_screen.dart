import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:datemate/statemanagement/user_provider.dart';
import 'package:datemate/utils/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

class Profile1Screen extends ConsumerStatefulWidget {
  static const String route = "Profile1Screen";

  PageController? pageController;
  Profile1Screen({required this.pageController});

  @override
  _Profile1ScreenState createState() => _Profile1ScreenState();
}

class _Profile1ScreenState extends ConsumerState<Profile1Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  File? _img;

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final usrProvider = ref.read(userProvider);

    if (usrProvider.user != null) {
      _img = usrProvider.user!.imageFile!;
      _firstNameController.text = usrProvider.user!.firstName ?? '';
      _lastNameController.text = usrProvider.user!.lastName ?? '';
      _selectedDate = usrProvider.user!.birthday ?? DateTime.now();
    }
  }

  Future _browseImage(ImageSource imageSource) async {
    try {
      // Source is either Gallary or Camera
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _img = File(image.path);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> uploadImageToFirebaseStorage(String filename) async {
    if (_img == null) {
      throw Exception('Image file is null.');
    }

    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('images/$filename');
      final uploadTask = storageRef.putFile(_img!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
      throw Exception('Image upload failed.');
    }
  }

  // void _submitForm(BuildContext context) async {}

  // Validation functions
  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name.';
    }
    // Add additional validation logic if needed
    return null; // Return null if the input is valid
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your last name.';
    }
    // Add additional validation logic if needed
    return null; // Return null if the input is valid
  }

  @override
  void dispose() {
    // Dispose focus nodes
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text('Profile details',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SKModernistBold',
                                    color: Color.fromARGB(255, 44, 44, 44))),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SafeArea(
                                  child: Container(
                                    child: Wrap(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            _browseImage(ImageSource.camera);
                                          },
                                          child: ListTile(
                                            leading: Icon(Icons.camera_alt),
                                            title: Text('Take a photo'),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            _browseImage(ImageSource.gallery);
                                          },
                                          child: ListTile(
                                            leading: Icon(Icons.photo_library),
                                            title: Text('Choose from gallery'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              shape: BoxShape.circle,
                              image: _img != null
                                  ? DecorationImage(
                                      image: FileImage(_img!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _img == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey,
                                        size: 50,
                                      ),
                                      Text(
                                        'Upload',
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Column(
                      children: [
                        TextFormField(
                          controller: _firstNameController,
                          focusNode: _firstNameFocusNode,
                          validator: _validateFirstName,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 216, 216, 216),
                                  )),
                              labelText: 'Enter your first name',
                              labelStyle: TextStyle(fontSize: 14)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          focusNode: _lastNameFocusNode,
                          validator: _validateLastName,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  )),
                              labelText: 'Enter your last name',
                              labelStyle: TextStyle(fontSize: 14)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            _lastNameFocusNode.unfocus();
                            final DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            print(_selectedDate);
                            if (selectedDate != null) {
                              setState(() {
                                // update selected date
                                _selectedDate = selectedDate;
                              });
                            }
                          },
                          child: Container(
                            height: 55,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 232, 234),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Color.fromARGB(255, 215, 78, 91),
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Select your birthday',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 215, 78, 91)),
                                ),
                                Spacer(),
                                Text(
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (_img != null) {
                                  if (_formKey.currentState!.validate()) {
                                    final usrProvider = ref.read(userProvider);

                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircularProgressIndicator(), // Replace this with your custom loading widget
                                              SizedBox(height: 16),
                                              Text('Processing...'),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                    try {
                                      // Simulating a delay
                                      await Future.delayed(
                                          Duration(seconds: 1));

                                      String timestamp =
                                          DateFormat('yyyyMMdd_HHmmss')
                                              .format(DateTime.now());
                                      String filename = 'image_$timestamp';

                                      String imgUrl =
                                          await uploadImageToFirebaseStorage(
                                              filename);
                                      usrProvider.updateUser(
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                          birthday: _selectedDate,
                                          imageFile: _img,
                                          image: imgUrl);

                                      // if (_img != null) {
                                      //   final currentImage =
                                      //       usrProvider.user?.image;
                                      //   if (currentImage != _img!.path) {
                                      //     final reference = FirebaseStorage
                                      //         .instance
                                      //         .ref()
                                      //         .child(
                                      //             'images/${DateTime.now().millisecondsSinceEpoch}');
                                      //     final task = reference.putFile(_img!);
                                      //     await task;
                                      //     final url =
                                      //         await reference.getDownloadURL();
                                      //     usrProvider.updateUser(image: url);
                                      //   }
                                      // } else if (usrProvider.user?.image ==
                                      //     null) {
                                      //   Navigator.pop(
                                      //       context); // Dismiss the loading dialog
                                      //   ShowSnackbar.showCustomSnackbar(
                                      //     context,
                                      //     title: 'On Snap!',
                                      //     message:
                                      //         'Looks like you didn\'t upload a profile picture',
                                      //     contentType: ContentType.failure,
                                      //   );
                                      //   return;
                                      // }

                                      widget.pageController!.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );

                                      Navigator.pop(context);

                                      // Dismiss the loading dialog
                                    } catch (e) {
                                      Navigator.pop(
                                          context); // Dismiss the loading dialog
                                      // Handle any errors here
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    'Error in processing user profile, please try again!'),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Please add a profile picture',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Continue'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
