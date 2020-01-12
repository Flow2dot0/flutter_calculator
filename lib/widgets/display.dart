import 'package:flutter/material.dart';

class Display extends StatelessWidget {

  final String currentNumber;
  final double textScaleFactor;

  Display({@required this.currentNumber, this.textScaleFactor = 4});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      color: Colors.black87,
      child: Container(
        height: 200,
        child: Center(
          child: Text(
            currentNumber,
            textScaleFactor: textScaleFactor,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
