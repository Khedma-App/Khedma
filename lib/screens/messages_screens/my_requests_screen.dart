import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

/// Placeholder screen for incoming job requests (provider-only).
///
/// Will be wired to a Firestore `service_requests` collection
/// once the booking pipeline is complete.
class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kWidth(40)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Empty-state icon
            Icon(
              Icons.assignment_outlined,
              size: kSize(80),
              color: Colors.grey[300],
            ),
            SizedBox(height: kHeight(16)),

            // Title
            Text(
              'لا توجد طلبات حالياً',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: kSize(18),
                fontWeight: FontWeight.w800,
                color: Colors.grey[600],
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: kHeight(8)),

            // Subtitle
            Text(
              'عندما يطلب عميل خدمتك، ستظهر الطلبات هنا',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: kSize(13),
                fontWeight: FontWeight.w600,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
