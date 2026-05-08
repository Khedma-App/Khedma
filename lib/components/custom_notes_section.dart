import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomNotesSection extends StatelessWidget {
  final TextEditingController controller;

  const CustomNotesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kSize(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'ملاحظات إضافية (اختياري)',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: kSize(16),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF211B12),
            ),
          ),
          SizedBox(height: kHeight(8)),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              controller: controller,
              maxLines: 4,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: kSize(14),
                color: const Color(0xFF211B12),
              ),
              decoration: InputDecoration(
                hintText: 'أضف أي ملاحظات حول الدفع أو العمل المنجز...',
                hintStyle: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: kSize(13),
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(kSize(16)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kSize(12)),
                  borderSide: const BorderSide(color: Color(0xFFD6C4AE)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kSize(12)),
                  borderSide: const BorderSide(
                    color: Color(0xFFF2A93B),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
