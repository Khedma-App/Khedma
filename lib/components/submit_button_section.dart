import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomSubmitButtonSection extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomSubmitButtonSection({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kSize(20)),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE8A020), // نفس لون الصورة
              minimumSize: Size(double.infinity, kHeight(52)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kSize(12)),
              ),
              elevation: 0,
            ),
            child: Text(
              'إرسال النوتة للعامل',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: kSize(16),
                fontWeight: FontWeight.bold,
                color: Color(0xff5B3B00),
              ),
            ),
          ),
          SizedBox(height: kHeight(8)),
          // النص التوضيحي أسفل الزر
          Text(
            'ستصل النوتة للعامل وينتظر تأكيده',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: kSize(16),
              color: const Color(0xFF514534),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
