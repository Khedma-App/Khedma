import 'package:flutter/material.dart';

var kPrimaryColor = const Color(0x80E19113);

late double kScreenWidth; // to store screen width
late double kScreenHeight; // to store screen height
// دول القيم اللي هنستخدمها بعد كده في التطبيق

// الدالة دي هتستدعى في بداية التطبيق عشان ناخد منها مقاسات الشاشة
void initScreenSize(BuildContext context) {
  kScreenWidth = MediaQuery.of(context).size.width;
  kScreenHeight = MediaQuery.of(context).size.height;
}

// أبعاد التصميم الثابتة
const double kDesignHeight = 845.0;
const double kDesignWidth = 390.0;

// دالة الارتفاع
double kHeight(double value) {
  return kScreenHeight * (value / kDesignHeight);
}

// دالة العرض
double kWidth(double value) {
  return kScreenWidth * (value / kDesignWidth);
}

// دي لو الويدجيت اللي شغال بيها شغاله ب سايز مش ويدس و هايت
double kSize(double value) {
  return kScreenWidth * (value / kDesignWidth);
}


