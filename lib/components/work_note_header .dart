import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class WorkNoteHeader extends StatelessWidget {
  final String name;
  final String job;
  final String orderId;
  final String image;

  const WorkNoteHeader({
    super.key,
    required this.name,
    required this.job,
    required this.orderId,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kHeight(120),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF00A27A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(kSize(25))),
      ),
      padding: EdgeInsets.only(top: kSize(7)),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFF9F1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: kSize(20),
          vertical: kSize(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: kWidth(50),
              height: kHeight(5),
              decoration: BoxDecoration(
                color: const Color(0xFFD4C1AD),
                borderRadius: BorderRadius.circular(kSize(10)),
              ),
            ),

            SizedBox(height: kSize(20)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // اليوزر
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(kSize(2)),
                      decoration: const BoxDecoration(
                        color: Color(0xffD6C4AE),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: kSize(28),
                        backgroundImage: NetworkImage(image),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: kSize(16),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF211B12),
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 4),

                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: kHeight(4),
                            horizontal: kWidth(12),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8A32D),
                            borderRadius: BorderRadius.circular(kSize(25)),
                          ),
                          child: Text(
                            job,
                            style: TextStyle(
                              color: const Color(0xff5B3B00),
                              fontSize: kSize(12),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // العنوان
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'نوتة العمل',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: kSize(20),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF211B12),
                      ),
                    ),
                    Text(
                      orderId,
                      style: TextStyle(
                        fontSize: kSize(13),
                        color: const Color(0xFF757575),
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
