import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class FinishFlag extends StatelessWidget {
  const FinishFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: kWidth(230),
        height: kHeight(40),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: kWidth(12)),
        decoration: BoxDecoration(
          color: const Color(0xFFF39C12),
          borderRadius: BorderRadius.circular(kSize(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'العامل يريد انهاء العمل',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: kSize(14),
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
              ),
            ),

            SizedBox(width: kWidth(10)),

            Image.asset(
              'assets/icons/finish_flag.png',
              width: kWidth(24),
              height: kHeight(24),
            ),
          ],
        ),
      ),
    );
  }
}
