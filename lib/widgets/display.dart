import 'package:flutter/material.dart';

class Display extends StatelessWidget {

  final String currentNumber;

  Display({@required this.currentNumber});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      color: Colors.blueAccent[100],
      child: Container(
        height: 200,
        child: Center(
          child: Text(
            currentNumber,
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
