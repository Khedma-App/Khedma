import 'package:flutter/material.dart';

class TextValidator {
  static bool hasExternalCommunication(String text) {
    // Egyptian phone numbers (e.g. 010, 011, 012, 015) in English or Arabic digits with optional spaces/dashes
    final egPhoneRegex = RegExp(
        r'(?:[0\u0660][\s\.\-]*[1\u0661][\s\.\-]*[0125\u0660\u0661\u0662\u0665][\s\.\-]*)(?:[\d\u0660-\u0669][\s\.\-]*){8}');
    
    // Generic contiguous 10+ digits (to catch numbers written without spaces)
    final contiguousPhoneRegex = RegExp(r'[\d\u0660-\u0669]{10,}');
    
    final badWords = [
      'رقمي', 'رقمك', 'تليفون', 'واتس', 'واتساب', 'مستقل', 
      'برا التطبيق', 'خارج التطبيق', 'فون', 'موبايل', 'اتصال',
      'رقم الهاتف', 'رقم هاتف', 'الرقم', 'رقم الجوال', 'رقم تليفون',
      'رقم التليفون', 'ابعت رقمك', 'هات رقمك', 'رقم واتس'
    ];

    bool hasBadWord = badWords.any((word) => text.toLowerCase().contains(word));
    bool hasPhone = egPhoneRegex.hasMatch(text) || contiguousPhoneRegex.hasMatch(text);

    return hasBadWord || hasPhone;
  }

  static bool validateAll(BuildContext context, List<String> texts) {
    for (String text in texts) {
      if (hasExternalCommunication(text)) {
        FocusScope.of(context).unfocus(); // hide keyboard
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('تنبيه هام', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.red)),
                const SizedBox(width: 8),
                const Icon(Icons.warning_amber_rounded, color: Colors.red),
              ],
            ),
            content: const Text(
              'غير مسموح بمشاركة أرقام الهواتف أو طلب التواصل خارج التطبيق لحماية حقوقك.',
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w600),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('حسناً', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Color(0xFFF39C12))),
              ),
            ],
          ),
        );
        return true; // Fraud detected
      }
    }
    return false; // Clean
  }

  static void validateExternalCommunication(
      BuildContext context, String text, TextEditingController controller) {
    if (hasExternalCommunication(text)) {
      controller.text = ''; // Clear text directly
      validateAll(context, [text]); // Show the snackbar
    }
  }
}
