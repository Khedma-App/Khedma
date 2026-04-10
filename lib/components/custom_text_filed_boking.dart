import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class Custom_Text_Field_Booking_Screen extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final double? width;

  const Custom_Text_Field_Booking_Screen({
    super.key,
    required this.hintText,
    this.controller,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? kWidth(320),
      height: kHeight(35),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        border: Border.all(color: const Color(0xFFD1D1D1), width: 0.8),
        borderRadius: BorderRadius.circular(kSize(12)),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.center,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: kSize(14),
          height: 1.2,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: kSize(12),
            color: const Color(0xFF9E9E9E),
            fontWeight: FontWeight.bold,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: kWidth(12)),
        ),
      ),
    );
  }
}
