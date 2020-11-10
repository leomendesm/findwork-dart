import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignOutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignOutPageState();
  }
}

class SignOutPageState extends State<SignOutPage> {
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("jwt", null);
    return;
  }

  Widget build(context) {
    logout();
    Future.delayed(Duration.zero, () async {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });

    return Container();
  }
}
