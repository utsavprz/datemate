import 'package:datemate/screen/Auth/auth_screen.dart';
import 'package:datemate/statemanagement/user_provider.dart';
import 'package:datemate/utils/account_listtile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreen extends ConsumerStatefulWidget {
  // const AccountScreen({super.key});
  static const String route = 'AccountScreen';

  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: SizedBox(
              width: double.infinity,
              // color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            '${user.user!.image}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Text(
                            '${user.user!.firstName} ${user.user!.lastName}',
                            style: TextStyle(),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${user.user!.lat} ${user.user!.lon}',
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),
                ],
              ),
            )),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              width: double.infinity,
              // color: Colors.yellow,
              child: Column(
                children: [
                  AccountListTile(
                      tileLeading: 'My Profile',
                      tileRoute: 'Previous donation records',
                      tileIcon: const Icon(
                        Icons.account_circle,
                        color: Color.fromARGB(255, 236, 76, 65),
                      ),
                      tileFunction: () {
                        // ignore: use_build_context_synchronously
                      }),
                  AccountListTile(
                      tileLeading: 'Notification',
                      tileRoute: 'Blood request records',
                      tileIcon: const Icon(
                        Icons.notifications,
                        color: Color.fromARGB(255, 236, 76, 65),
                      ),
                      tileFunction: () {
                        // ignore: use_build_context_synchronously
                      }),
                  AccountListTile(
                      tileLeading: 'FAQ',
                      tileRoute: 'Blood request records',
                      tileIcon: const Icon(
                        Icons.question_answer_rounded,
                        color: Color.fromARGB(255, 236, 76, 65),
                      ),
                      tileFunction: () {
                        // ignore: use_build_context_synchronously
                      }),
                  AccountListTile(
                      tileLeading: 'Need help?',
                      tileRoute: 'Blood request records',
                      tileIcon: const Icon(
                        Icons.help_outlined,
                        color: Color.fromARGB(255, 236, 76, 65),
                      ),
                      tileFunction: () {
                        // ignore: use_build_context_synchronously
                      }),

                  AccountListTile(
                      tileLeading: 'Logout',
                      tileRoute: 'Logout',
                      tileColor: Colors.red,
                      tileIcon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.red,
                      ),
                      tileFunction: () async {
                        debugPrint('Logout');
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(
                            context, AuthScreen.route);
                      }),
                  // AccountListTile(
                  //     tileLeading: 'Token',Firebase
                  //     tileRoute: 'Token',
                  //     tileColor: Colors.grey,
                  //     tileIcon: const Icon(
                  //       Icons.key,
                  //       color: Colors.grey,
                  //     ),
                  //     tileFunction: () async {
                  //       String? token = await SharedPref.getTokenFromPrefs();

                  //       debugPrint(token);
                  //     }),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
