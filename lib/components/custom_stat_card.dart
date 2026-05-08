import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const CustomStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: kHeight(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kSize(12)),
        border: Border.all(color: const Color(0xFFEEE0D3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: kSize(20)),
          ),
          SizedBox(height: kHeight(10)),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: kSize(18),
              fontWeight: FontWeight.w900,
              color: Color(0xff211B12),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: kSize(12),
              color: Color(0xff5F5E5B),
            ),
          ),
        ],
      ),
    );
  }
}
