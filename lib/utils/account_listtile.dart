import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  String tileLeading;
  Icon tileIcon;
  String tileRoute;
  Color? tileColor;
  VoidCallback? tileFunction;

  AccountListTile({
    super.key,
    required this.tileLeading,
    required this.tileIcon,
    required this.tileRoute,
    this.tileColor,
    this.tileFunction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tileFunction,
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
        child: ListTile(
          leading: tileIcon,
          horizontalTitleGap: 0,
          title: Text(
            tileLeading,
            style: TextStyle(
              color: tileColor ?? const Color.fromARGB(255, 49, 49, 49),
              fontSize: 12,
              fontFamily: tileLeading == 'Logout'
                  ? 'Raleway SemiBold'
                  : 'Raleway Medium',
            ),
          ),
        ),
      ),
    );
  }
}
