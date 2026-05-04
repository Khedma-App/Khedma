import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomLogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color backgroundColor;

  const CustomLogoutButton({
    super.key,
    required this.onTap,
    this.title = "تسجيل الخروج",
    this.backgroundColor = const Color(0xffEF1818),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: kWidth(250),
        height: kHeight(40),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: kSize(15),
            ),
          ),
        ),
      ),
    );
  }
}
