import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  static const String route = 'FAQScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Color.fromARGB(255, 212, 212, 212))),
                      child: IconButton(
                        splashRadius: 1,
                        icon: Icon(
                          Icons.chevron_left_sharp,
                          color: Color.fromARGB(255, 215, 78, 91),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FAQ',
                          style: TextStyle(                                                                                                                                                                                           
                            fontSize: 24.0,
                            fontFamily: 'SKModernistBold',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              FAQCard(
                question: 'How do I create a profile?',
                answer:
                    'To create a profile, click on the "Create Profile" button on the home screen and follow the instructions.',
              ),
              SizedBox(height: 16.0),
              FAQCard(
                question: 'How can I change my preferences?',
                answer:
                    'You can change your preferences by going to the settings page and selecting the "Preferences" tab.',
              ),
              SizedBox(height: 16.0),
              FAQCard(
                question: 'What should I do if I forgot my password?',
                answer:
                    'If you forgot your password, click on the "Forgot Password" link on the login screen and follow the steps to reset your password.',
              ),
              SizedBox(height: 16.0),
              FAQCard(
                question: 'How can I report a user?',
                answer:
                    'If you want to report a user, go to their profile page and click on the "Report User" button. Provide the necessary details and our team will review the report.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQCard extends StatelessWidget {
  final String question;
  final String answer;

  FAQCard({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(answer),
          ],
        ),
      ),
    );
  }
}
