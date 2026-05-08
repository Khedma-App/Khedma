import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomPendingRequestCard extends StatelessWidget {
  const CustomPendingRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kHeight(180),
      width: kWidth(280),
      margin: EdgeInsets.symmetric(
        horizontal: kSize(18),
        vertical: kHeight(10),
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEE0D3), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A1A).withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: kWidth(40),
                height: kHeight(40),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF1F1F1),
                ),
                child: const Icon(Icons.person, color: Colors.grey),
              ),

              SizedBox(width: kSize(8)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "أحمد خالد",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: kSize(14),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                    SizedBox(height: kHeight(4)),
                    Text(
                      "إصلاح تسريب مياه",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: kSize(12),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              ///
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kSize(10),
                  vertical: kHeight(4),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4E6D8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "منذ ساعة",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: kSize(10),
                    color: const Color(0xFF8B6F4E),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: kHeight(8)),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  "150 - 200 ج",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: kSize(14),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE19113),
                  ),
                ),
                const Spacer(),
                Text(
                  ":التكلفة المتوقعة",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: kSize(12),
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: kHeight(15)),
          Row(
            children: [
              /// Reject
              Expanded(
                flex: 2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFD6D6D6)),
                    ),
                    child: const Center(
                      child: Text(
                        "رفض",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: kSize(8)),

              Expanded(
                flex: 3,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE19113),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "تفاصيل وقبول",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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
