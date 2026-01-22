import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class SectionItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const SectionItem({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onTap,
          child: Container(
            height: kHeight(92),
            width: kWidth(92),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: kWidth(57),
                height: kHeight(58),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(height: kHeight(8)),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF838383),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Laila',
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
