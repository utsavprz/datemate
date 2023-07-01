import 'package:datemate/screen/home_screen.dart';
import 'package:datemate/statemanagement/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class FinalizingScreen extends ConsumerStatefulWidget {
  const FinalizingScreen({super.key});
  static const String route = 'FinalizingScreen';

  @override
  _FinalizingScreenState createState() => _FinalizingScreenState();
}

class _FinalizingScreenState extends ConsumerState<FinalizingScreen> {
  double? lat;
  double? lon;
  @override
  void initState() {
    // TODO: implement initState
    final usrProvider = ref.read(userProvider);
    usrProvider.uploadUserDataToFirebase();
    _initLocationService();
    // Future.delayed(Duration(seconds: 5)).then(
    //     (value) => {)});
    super.initState();
  }

  Future<void> _initLocationService() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location services are disabled';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot proceed further';
      }

      Position position = await Geolocator.getCurrentPosition();
      print(position.latitude);
      print(position.longitude);
      lat = position.latitude;
      lon = position.longitude;

      print('Location granted');

      await _updateUserDataToFirebase();
      await ref.read(userProvider).fetchUserDataFromFirebase();
      Navigator.pushReplacementNamed(context, HomeScreen.route);
    } catch (error) {
      print('Error during location service initialization: $error');
      // Handle the error gracefully
    }
  }

  Future<void> _updateUserDataToFirebase() async {
    final usrProvider = ref.read(userProvider);
    await usrProvider.updateUserDataToFirebase(lat: lat, lon: lon);
    print('updated data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 20,
            ),
            Text('We are finalizing your profile setup',
                style: TextStyle(fontFamily: 'SKModernistRegular'))
          ],
        ),
      ),
    );
  }
}
