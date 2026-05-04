import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomProfileOptionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool hasNotification;
  final VoidCallback onTap;

  const CustomProfileOptionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: kHeight(60),
        width: double.infinity,
        margin: EdgeInsets.only(bottom: kSize(12)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kSize(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: kSize(12),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (hasNotification)
              Icon(
                Icons.circle,
                color: const Color(0xFFE19113),
                size: kSize(15),
              )
            else
              const SizedBox(width: 10),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: kSize(15),
              ),
            ),
            const SizedBox(width: 12),
            Icon(icon, color: const Color(0xFFE19113), size: 22),
          ],
        ),
      ),
    );
  }
}
