import 'package:flutter/material.dart';
import 'package:graphqlex/main.dart';
import './items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomePage> {
  bool show = false;

  List<Widget> slides = items.map((item) {
    if (item['header'] == 'last') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(''),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Find Work',
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan[600],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30),
                    ),
                    RaisedButton(
                      onPressed: () {
                        navigatorKey.currentState.pushNamed('/signup');
                      },
                      child: Text(
                        'Criar uma conta',
                      ),
                      color: Colors.cyan[600],
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        navigatorKey.currentState.pushNamed('/signin');
                      },
                      child: Text(
                        'Já possuo uma conta',
                      ),
                      color: Colors.cyan[800],
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Image.asset(
              item['image'],
              fit: BoxFit.fitWidth,
              width: 220.0,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: <Widget>[
                  Text(
                    item['header'],
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w300,
                      color: Color(0XFF3F3D56),
                    ),
                  ),
                  Text(
                    item['description'],
                    style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 1.2,
                        fontSize: 16.0,
                        height: 1.3),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }).toList();
  List<Widget> indicator() => List<Widget>.generate(
        slides.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 3.0),
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
              color: currentPage.round() == index
                  ? Color(0XFF256075)
                  : Color(0XFF256075).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.0)),
        ),
      );

  double currentPage = 0.0;
  final _pageViewController = new PageController();

  void autoLogIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _jwt = prefs.getString("jwt");
    if (_jwt != null && _jwt != "") {
      navigatorKey.currentState.pushNamedAndRemoveUntil(
        '/home',
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        show = true;
      });
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return Scaffold(
        backgroundColor: Colors.cyan[800],
      );
    }
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageViewController,
              itemCount: slides.length,
              itemBuilder: (BuildContext context, int index) {
                _pageViewController.addListener(() {
                  setState(() {
                    currentPage = _pageViewController.page;
                  });
                });
                return slides[index];
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(top: 70.0),
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: indicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
