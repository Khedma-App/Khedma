import 'package:flutter/material.dart';

var kPrimaryColor = const Color(0xFFE19113);
// bool isFirstTime = false; // to track if it's the first time user logs in

late double kScreenWidth; // to store screen width
late double kScreenHeight; // to store screen height

void initScreenSize(BuildContext context) {
  kScreenWidth = MediaQuery.of(context).size.width;
  kScreenHeight = MediaQuery.of(context).size.height;
}

const double kDesignHeight = 845.0;
const double kDesignWidth = 390.0;

double kHeight(double value) {
  return kScreenHeight * (value / kDesignHeight);
}

double kWidth(double value) {
  return kScreenWidth * (value / kDesignWidth);
}

double kSize(double value) {
  return kScreenWidth * (value / kDesignWidth);
}
