import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  UserInfo({@required this.data, @required this.icon});
  final data;
  final icon;
  @override
  Widget build(BuildContext context) {
    Widget iconComponent;
    if (icon != null) {
      iconComponent = Icon(
        icon,
        color: Colors.white,
      );
    } else {
      iconComponent = Container();
    }
    return Row(
      children: [
        iconComponent,
        Padding(
          padding: EdgeInsets.only(left: 5),
        ),
        Text(
          "$data",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
