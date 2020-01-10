import 'package:flutter/material.dart';

class KeyPad extends ButtonTheme{

  KeyPad({@required onPressed, @required String label,
    double height = 100, double minWidth = 100, Color backgroundColor = Colors.redAccent, Color color = Colors.white, }):
      super(
        height: height,
        minWidth: minWidth,
        child: RaisedButton(
          padding: EdgeInsets.only(top: 25.0, bottom: 25.0, left: 20.0, right: 20.0),
          elevation: 8.0,
          onPressed: onPressed,
          color: backgroundColor,
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 30.0
            ),
          ),
        ),
      );
}