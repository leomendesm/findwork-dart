import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SpeedDialButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      // both default to 16
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.biotech),
          backgroundColor: Colors.teal,
          label: 'Adicionar projeto',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => Navigator.pushNamed(context, '/projectform'),
        ),
        SpeedDialChild(
          child: Icon(Icons.business_center),
          backgroundColor: Colors.blue,
          label: 'Adicionar histórico',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => Navigator.pushNamed(context, '/historicalform'),
        ),
      ],
    );
  }
}
