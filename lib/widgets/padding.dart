import 'package:flutter/material.dart';

Padding paddingBox({top: 0.0, right: 0.0, bottom: 0.0, left: 0.0}) {
  return Padding(
    padding: EdgeInsets.only(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
    ),
  );
}
