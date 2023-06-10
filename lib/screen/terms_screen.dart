import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  static const String route = "TermsOfUseScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Row(children: [
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
            ]),
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
                        'Terms of Use',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Please read these terms of use carefully before using the dating app.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '1. Acceptance of Terms',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'By accessing and using the dating app, you agree to be bound by these terms of use and all applicable laws and regulations.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '2. Eligibility',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'You must be at least 18 years old to use the dating app. By using the app, you confirm that you are of legal age.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '3. User Conduct',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'You agree to use the dating app responsibly and in compliance with all applicable laws. You are solely responsible for your interactions with other users and for any content you post on the app.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '4. Privacy Policy',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'By using the app, you acknowledge and agree to the terms of our Privacy Policy. Please review the Privacy Policy carefully to understand how we collect, use, and disclose your personal information.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '5. Intellectual Property',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'All intellectual property rights in the dating app, including but not limited to trademarks, copyrights, and patents, belong to the app owner. You may not use or reproduce any app content without prior written permission.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ), // ...

                      SizedBox(height: 16),
                      Text(
                        '6. Prohibited Activities',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'You agree not to engage in any of the following prohibited activities:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '- Harass, threaten, or intimidate other users',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '- Transmit any viruses or malicious code',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '- Violate any applicable laws or regulations',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      // ...

                      SizedBox(height: 16),
                      Text(
                        '7. Termination',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'We reserve the right to terminate or suspend your access to the dating app at any time for any reason without notice or liability.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      // ...

                      SizedBox(height: 16),
                      Text(
                        '8. Contact Us',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'If you have any questions or concerns regarding these terms of use, please contact us at [email protected]',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ])),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

            // Add more sections and content as necessary
