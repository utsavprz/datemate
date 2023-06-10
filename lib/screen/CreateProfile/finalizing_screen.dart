import 'package:datemate/screen/home_screen.dart';
import 'package:datemate/statemanagement/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinalizingScreen extends ConsumerStatefulWidget {
  const FinalizingScreen({super.key});
  static const String route = 'FinalizingScreen';

  @override
  _FinalizingScreenState createState() => _FinalizingScreenState();
}

class _FinalizingScreenState extends ConsumerState<FinalizingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    final usrProvider = ref.read(userProvider);
    usrProvider.uploadUserDataToFirebase();
    Future.delayed(Duration(seconds: 5)).then(
        (value) => {Navigator.pushReplacementNamed(context, HomeScreen.route)});
    super.initState();
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
