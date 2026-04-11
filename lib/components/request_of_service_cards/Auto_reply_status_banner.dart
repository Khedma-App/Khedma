import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class AutoReplyStatusBanner extends StatelessWidget {
  const AutoReplyStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: kWidth(304),
        height: kHeight(40),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF39C12),
          borderRadius: BorderRadius.circular(kSize(15)),
        ),
        child: Text(
          'إذا لم تؤكد خلال 48 ساعة سيتم إنهاء الطلب تلقائيًا',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: kSize(12),
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}
