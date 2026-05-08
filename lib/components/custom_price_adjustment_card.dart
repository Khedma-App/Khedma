import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomPriceAdjustmentCard extends StatelessWidget {
  const CustomPriceAdjustmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kWidth(280),
      height: kHeight(277.5),
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
          top: BorderSide(color: const Color(0xFF3498DB), width: kWidth(4)),
          right: const BorderSide(color: Color(0xFF3498DB), width: 1),
          bottom: const BorderSide(color: Color(0xFF3498DB), width: 1),
          left: const BorderSide(color: Color(0xFF3498DB), width: 1),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF5FB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'العامل عدل المبلغ',
                  style: TextStyle(
                    color: const Color(0xFF3498DB),
                    fontSize: kHeight(10),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CN-2026-00847',
                style: TextStyle(
                  fontSize: kHeight(14),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'كود النوتة',
                style: TextStyle(
                  fontSize: kHeight(14),
                  fontWeight: FontWeight.bold,
                  color: Color(0xff514534),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '5,400 ج',
                    style: TextStyle(
                      fontSize: kHeight(14),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Text(
                    '6,000 ج',
                    style: TextStyle(
                      fontSize: kHeight(20),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE8A020),
                    ),
                  ),
                ],
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'يوم عمل إضافي',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff211B12),
                  fontSize: kHeight(14),
                ),
              ),
              Text(
                'سبب التعديل',
                style: TextStyle(
                  fontSize: kHeight(14),
                  fontWeight: FontWeight.bold,
                  color: Color(0xff514534),
                ),
              ),
            ],
          ),

          const Divider(thickness: 1),

          Column(
            children: [
              Container(
                width: double.infinity,
                height: kHeight(35),
                decoration: BoxDecoration(
                  color: const Color(0xFF2ECC71),
                  borderRadius: BorderRadius.circular(kHeight(8)),
                ),
                alignment: Alignment.center,
                child: Text(
                  'موافقة على التعديل',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: kHeight(13),
                  ),
                ),
              ),
              SizedBox(height: kHeight(8)),
              Container(
                width: double.infinity,
                height: kHeight(35),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kHeight(8)),
                  border: Border.all(color: const Color(0xFFC0392B)),
                ),
                alignment: Alignment.center,
                child: Text(
                  'رفض وفتح نزاع',
                  style: TextStyle(
                    color: const Color(0xFFBA1A1A),
                    fontWeight: FontWeight.bold,
                    fontSize: kHeight(13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
