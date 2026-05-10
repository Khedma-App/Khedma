import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

/// A polished empty-state placeholder with icon, title, subtitle, and optional
/// action button. Used across all list screens.
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onActionPressed;
  final String? actionButtonText;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onActionPressed,
    this.actionButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(kSize(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(kSize(24)),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4E5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: kSize(64), color: const Color(0xFFE19113)),
            ),
            SizedBox(height: kHeight(24)),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: kSize(18),
                fontWeight: FontWeight.w800,
                color: const Color(0xFF211B12),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: kHeight(8)),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: kSize(13),
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (onActionPressed != null && actionButtonText != null) ...[
              SizedBox(height: kHeight(24)),
              ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE19113),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: kSize(32),
                    vertical: kHeight(12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  actionButtonText!,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
