import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class BuildToggleItem extends StatelessWidget {
  const BuildToggleItem({
    super.key,
    required this.text,
    required this.isActive,
    required this.onTap,
  });
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: kHeight(42),
        width: kWidth(160),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: isActive ? Colors.orange : Colors.transparent,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF838383),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
