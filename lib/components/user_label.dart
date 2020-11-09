import 'package:flutter/material.dart';

class UserLabel extends StatelessWidget {
  UserLabel({@required this.label});
  final label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 5),
      child: Text(
        "$label",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
