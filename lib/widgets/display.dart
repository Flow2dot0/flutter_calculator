import 'package:flutter/material.dart';

class Display extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      color: Colors.blueAccent[100],
      child: Container(
        height: 200,
        child: Center(
          child: Text(
            '00000000',
            textScaleFactor: 4,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
