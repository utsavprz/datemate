import 'package:datemate/statemanagement/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Profile3Screen extends ConsumerStatefulWidget {
  PageController? pageController;
  Profile3Screen({required this.pageController});
  static const String route = 'Profile3Screen';
  @override
  _Profile3ScreenState createState() => _Profile3ScreenState();
}

class Interest {
  final int id;
  final String name;

  Interest({
    required this.id,
    required this.name,
  });
}

class _Profile3ScreenState extends ConsumerState<Profile3Screen> {
  @override
  void initState() {
    super.initState();
    final usrProvider = ref.read(userProvider);

    print(usrProvider.user!.interest);
    if (usrProvider.user != null) {
      setState(() {
        _selectedInterests = usrProvider.user!.interest ?? [];
      });
    }
  }

  static List<String> _interests = [
    "Adventure Seeker",
    "Food Lover",
    "Art Enthusiast",
    "Fitness Fanatic",
    "Movie Aficionado",
    "Music Junkie",
    "Tech Geek",
    "Fashion Lover",
    "Nature Explorer",
    "Bookworm",
    "Coffee Lover",
    "Gamer",
    "Photography Enthusiast",
    "Cooking Enthusiast",
    "Dog Lover",
    "Fashion Design",
    "Entrepreneur",
    "Surfer",
    "Music Producer",
    "Yoga Practitioner",
    "Hiker",
    "Scuba Diver",
    "Social Activist",
    "Sustainable Living",
    "Craft Beer Enthusiast",
    "Astrology Enthusiast",
    "Travel Photographer"
  ];
  final _items = _interests
      .map((interest) => MultiSelectItem<String>(interest, interest))
      .toList();

  final _multiSelectKey = GlobalKey<FormFieldState>();

  List<String> _selectedInterests = [];
  @override
  Widget build(BuildContext context) {
    final usrProvider = ref.read(userProvider);
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, top: 50, bottom: 90),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text('Your interests',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SKModernistBold',
                              color: Color.fromARGB(255, 44, 44, 44))),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                      'To suggest compatible matches, we\'d love to know more about your interests. What are your hobbies and passions, ${usrProvider.user!.firstName}? Tell me as much or as little as you\'d like'),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              // Color.fromARGB(41, 215, 78, 99)
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      child: MultiSelectBottomSheetField(
                        initialValue: _selectedInterests.isNotEmpty
                            ? _selectedInterests
                            : [],
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        initialChildSize: 0.4,
                        listType: MultiSelectListType.CHIP,
                        searchable: true,
                        buttonIcon: Icon(
                          Icons.interests,
                          color: Color.fromARGB(255, 218, 86, 86),
                        ),
                        buttonText: Text(
                          _selectedInterests.isEmpty
                              ? "Select your interests"
                              : "Remove interests",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 218, 86, 86)),
                        ),
                        title: Text(
                          "Interests",
                        ),
                        items: _items,
                        onConfirm: (values) {
                          setState(() {
                            _selectedInterests = values.cast();
                          });
                        },
                        chipDisplay: MultiSelectChipDisplay(
                          chipColor: Color.fromARGB(255, 215, 78, 91),
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'SKModernistBold'),
                          // icon: Icon(
                          //   Icons.close_rounded,
                          //   size: 5,
                          //   color: Colors.white,
                          // ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          // onTap: (value) {
                          //   setState(() {
                          //     _selectedInterests.remove(value);
                          //     // final usrProvider = ref.read(userProvider);
                          //     // usrProvider.updateUser(
                          //     //     interest: _selectedInterests);
                          //   });
                          // print(_selectedInterests);
                          // },
                        ),
                      ),
                    ),
                  ),
                  _selectedInterests == null || _selectedInterests.isEmpty
                      ? Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "None selected",
                            style: TextStyle(color: Colors.black54),
                          ))
                      : Container(),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_selectedInterests.isNotEmpty) {
                    if (_selectedInterests.length <= 8) {
                      final usrProvider = ref.read(userProvider);
                      usrProvider.updateUser(
                          interest: _selectedInterests,
                          id: FirebaseAuth.instance.currentUser!.uid);

                      widget.pageController!.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Please select only up to 8 interests.',
                          ),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'Your matches would love to know your interests!',
                      ),
                    ));
                  }
                },
                child: Text('Continue'),
              ),
            ],
          )
        ],
      ),
    )));
  }
}
