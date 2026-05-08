import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart'; // تأكد من المسار الصحيح لملف الثوابت

class CustomWorkCompletionCard extends StatelessWidget {
  const CustomWorkCompletionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kWidth(280),
      height: kHeight(182.5),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kSize(12)),
          bottomLeft: Radius.circular(kSize(12)),
          bottomRight: Radius.circular(kSize(12)),
          topRight: Radius.zero,
        ),
        border: Border(
          top: BorderSide(color: Color(0xFF2ECC71), width: kWidth(4)),
          right: BorderSide(color: Color(0xFF2ECC71), width: 1),
          bottom: BorderSide(color: Color(0xFF2ECC71), width: 1),
          left: BorderSide(color: Color(0xFF2ECC71), width: 1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusTag('في انتظار العامل'),
              Text(
                'نوتة إنهاء العمل',
                style: TextStyle(
                  fontSize: kHeight(15),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF211B12),
                ),
              ),
            ],
          ),

          _buildInfoRow('كود النوتة', 'CN-2026-00847'),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '5,400 ج',
                style: TextStyle(
                  fontSize: kHeight(18),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2ECC71),
                ),
              ),
              Text(
                'المبلغ المدفوع',
                style: TextStyle(
                  color: Color(0xff514534),
                  fontSize: kHeight(14),
                ),
              ),
            ],
          ),

          _buildInfoRow('طريقة الدفع', 'كاش في الموقع'),
          _buildInfoRow('التاريخ', '15 / 11 / 2026'),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3D7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFFE6A23C),
          fontSize: kHeight(10),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xff514534),
            fontSize: kHeight(14),
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Color(0xff514534), fontSize: kHeight(14)),
        ),
      ],
    );
  }
}
