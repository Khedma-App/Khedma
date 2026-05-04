import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomBottomActionBar extends StatelessWidget {
  final String saveText;
  final String cancelText;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const CustomBottomActionBar({
    super.key,
    this.saveText = "حفظ التغييرات",
    this.cancelText = "إلغاء",
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // زر الإلغاء (Bordered Button)
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kSize(12)),
                ),
                padding: EdgeInsets.symmetric(vertical: kSize(15)),
              ),
              child: Text(
                cancelText,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: kSize(15),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kSize(12)),
                ),
                padding: EdgeInsets.symmetric(vertical: kSize(15)),
              ),
              child: Text(
                saveText,
                style: TextStyle(
                  fontSize: kSize(15),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
