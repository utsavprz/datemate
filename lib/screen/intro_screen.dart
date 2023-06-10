import 'package:chat_bubbles/bubbles/bubble_special_three.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class IntroPage extends StatelessWidget {
  final Map<String, dynamic> text;
  final String image;
  final int index;
  const IntroPage(
      {super.key,
      required this.text,
      required this.image,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color.fromARGB(255, 255, 180, 205),
      width: 300,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset(
                    isAntiAlias: true,
                    image,
                  ),
                ],
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        text['title'],
                        style: const TextStyle(
                            fontSize: 20,
                            height: 1.5,
                            color: Color.fromARGB(215, 215, 78, 91),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        text['desc'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: Color.fromARGB(214, 52, 52, 52),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
