import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomConfirmedWorkCard extends StatelessWidget {
  const CustomConfirmedWorkCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kWidth(280),
      height: kHeight(190),
      padding: EdgeInsets.all(kHeight(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kHeight(12)),
          bottomLeft: Radius.circular(kHeight(12)),
          bottomRight: Radius.circular(kHeight(12)),
          topRight: Radius.zero,
        ),
        border: Border(
          top: BorderSide(color: const Color(0xFF2ECC71), width: kWidth(4)),
          right: const BorderSide(color: Color(0xFF2ECC71), width: 1),
          bottom: const BorderSide(color: Color(0xFF2ECC71), width: 1),
          left: const BorderSide(color: Color(0xFF2ECC71), width: 1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kSize(8),
                  vertical: kSize(2),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F5),
                  borderRadius: BorderRadius.circular(kSize(20)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: kHeight(10),
                      color: const Color(0xFF2ECC71),
                    ),
                    SizedBox(width: kWidth(4)),
                    Text(
                      'مؤكدة من الطرفين',
                      style: TextStyle(
                        color: const Color(0xFF2ECC71),
                        fontSize: kHeight(10),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'نوتة إنهاء العمل',
                style: TextStyle(
                  fontSize: kHeight(13),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF211B12),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CN-2026-00847',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff211B12),
                  fontSize: kHeight(14),
                ),
              ),
              Text(
                'كود النوتة',
                style: TextStyle(
                  color: const Color(0xff514534),
                  fontSize: kHeight(14),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '6,000 ج',
                style: TextStyle(
                  fontSize: kHeight(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2ECC71),
                ),
              ),
              Text(
                'المبلغ المدفوع',
                style: TextStyle(
                  color: const Color(0xff514534),
                  fontSize: kHeight(14),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const Divider(thickness: 0.5),

          Column(
            children: [
              _buildConfirmationRow('تأكيد العميل'),
              SizedBox(height: kHeight(4)),
              _buildConfirmationRow('تأكيد العامل'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationRow(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.check, size: kHeight(20), color: Colors.black),
        Text(
          text,
          style: TextStyle(
            fontSize: kHeight(16),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF211B12),
          ),
        ),
        SizedBox(width: kWidth(8)),

        SizedBox(width: kWidth(4)),
        Icon(
          Icons.check_circle_outline,
          size: kHeight(20),
          color: const Color(0xFF2ECC71),
        ),
      ],
    );
  }
}
