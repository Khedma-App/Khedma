import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart'; // تأكد من وجود ملف الثوابت للأبعاد

class CustomRequestsFactorHeader extends StatelessWidget {
  const CustomRequestsFactorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kHeight(100),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE19113),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: kHeight(35),
                width: kWidth(100),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
