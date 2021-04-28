import 'package:flutter/material.dart';

Text customText(String string, {factor: 1.0, color: Colors.white}) {
  return Text(
    string,
    textScaleFactor: factor,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: color,
    ),
  );
}
