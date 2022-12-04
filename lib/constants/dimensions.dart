import 'package:flutter/material.dart';

double getHeight({required BuildContext context}) {
  final displayHeight = MediaQuery.of(context).size.height;
  return displayHeight;
}

double getWidth({required BuildContext context}) {
  final displayWidth = MediaQuery.of(context).size.width;
  return displayWidth;
}
