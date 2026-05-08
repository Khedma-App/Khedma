import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class PaymentCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: kHeight(80),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF3E5) : Colors.white,
          borderRadius: BorderRadius.circular(kSize(12)),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFF2A93B)
                : const Color(0xFFD6C4AE),
            width: isSelected ? kSize(1.5) : kSize(1.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: kSize(14),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: const Color(0xFF211B12),
                ),
              ),
            ),
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFFF2A93B)
                  : const Color(0xFF8C867E),
              size: kSize(24),
            ),
            SizedBox(width: kWidth(12)),
          ],
        ),
      ),
    );
  }
}
