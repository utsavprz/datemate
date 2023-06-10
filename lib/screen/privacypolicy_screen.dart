import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const String route = "PrivacyPolicyScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                          context); // Navigate back when the back button is pressed
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromARGB(255, 212, 212, 212),
                        ),
                      ),
                      child: Icon(
                        Icons.chevron_left_sharp,
                        color: Color.fromARGB(255, 215, 78, 91),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SizedBox(
                  height: (MediaQuery.of(context).size.height * 0.8) -
                      MediaQuery.of(context).padding.top,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Your privacy is important to us. This Privacy Policy outlines how we collect, use, and protect your personal information when you use our dating app.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '1. Information We Collect',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'We may collect the following types of information:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '- Personal information (e.g., name, email address, date of birth)',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '- Usage information (e.g., app features accessed, interactions with other users)',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '2. How We Use Your Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'We may use your information for the following purposes:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '- To provide and personalize our services',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '- To communicate with you about app updates or promotional offers',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '3. Information Sharing and Disclosure',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'We may share your information in the following circumstances:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '- With other users as part of the app functionality',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                            '- With third-party service providers who assist us in operating the app',
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        SizedBox(height: 16),
                        Text(
                          '4. Data Security',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'We take appropriate security measures to protect your personal information from unauthorized access, alteration, or disclosure.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '5. Your Choices',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'You have the following choices regarding your personal information:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '- You can update or delete your profile information within the app settings',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '6. Changes to this Privacy Policy',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the updated policy on the app.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '7. Contact Us',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'If you have any questions or concerns regarding this Privacy Policy, please contact us at [email protected]',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
