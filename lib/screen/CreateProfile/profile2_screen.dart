import 'package:datemate/statemanagement/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile2Screen extends ConsumerStatefulWidget {
  static const String route = 'Profile2Screen';
  PageController? pageController;
  Profile2Screen({required this.pageController});
  @override
  _Profile2ScreenState createState() => _Profile2ScreenState();
}

class _Profile2ScreenState extends ConsumerState<Profile2Screen> {
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    final usrProvider = ref.read(userProvider);

    if (usrProvider.user != null) {
      _selectedGender = usrProvider.user!.gender ?? 'Male';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding:
            const EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 90),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('I am a',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SKModernistBold',
                        color: Color.fromARGB(255, 44, 44, 44))),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedGender = 'Male';
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: _selectedGender == 'Male'
                            ? Color.fromARGB(255, 215, 78, 91)
                            : Colors.white,
                        border: _selectedGender == 'Male'
                            ? null
                            : Border.all(
                                color: Color.fromARGB(255, 217, 217, 217)),
                        borderRadius: BorderRadius.circular(15)),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 3,
                      children: [
                        Icon(
                          Icons.male,
                          color: _selectedGender == 'Male'
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          'Male',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _selectedGender == 'Male'
                                ? Colors.white
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedGender = 'Female';
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: _selectedGender == 'Female'
                            ? Color.fromARGB(255, 215, 78, 91)
                            : Colors.white,
                        border: _selectedGender == 'Female'
                            ? null
                            : Border.all(
                                color: Color.fromARGB(255, 217, 217, 217)),
                        borderRadius: BorderRadius.circular(15)),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 3,
                      children: [
                        Icon(
                          Icons.male,
                          color: _selectedGender == 'Female'
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          'Female',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _selectedGender == 'Female'
                                ? Colors.white
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedGender = 'Other';
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: _selectedGender == 'Other'
                            ? Color.fromARGB(255, 215, 78, 91)
                            : Colors.white,
                        border: _selectedGender == 'Other'
                            ? null
                            : Border.all(
                                color: Color.fromARGB(255, 217, 217, 217)),
                        borderRadius: BorderRadius.circular(15)),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 3,
                      children: [
                        Icon(
                          Icons.male,
                          color: _selectedGender == 'Other'
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          'Other',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _selectedGender == 'Other'
                                ? Colors.white
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final usrProvider = ref.read(userProvider);
                    usrProvider.updateUser(gender: _selectedGender);

                    widget.pageController!.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text('Continue'),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
