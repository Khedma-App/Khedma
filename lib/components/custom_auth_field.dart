import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomAuthField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final VoidCallback onVerifyPressed;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomAuthField({
    super.key,
    required this.hintText,
    required this.keyboardType,
    required this.onVerifyPressed,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kWidth(354),
      margin: EdgeInsets.only(bottom: kHeight(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kSize(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: kSize(10),
            offset: Offset(0, kHeight(5)),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        validator: validator,
        style: TextStyle(fontSize: kSize(14), fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          filled: false,
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0x80838383),
            fontSize: kSize(12),
            fontWeight: FontWeight.w700,
          ),
          prefixIcon: GestureDetector(
            onTap: onVerifyPressed,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: kWidth(20),
                vertical: kHeight(12),
              ),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kSize(15)),
                  bottomLeft: Radius.circular(kSize(15)),
                ),
              ),
              child: Text(
                'تحقق',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: kSize(13),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kSize(15)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kSize(15)),
            borderSide: const BorderSide(color: Colors.orange, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kSize(15)),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kSize(15)),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: kWidth(15),
            vertical: kHeight(12),
          ),
          errorStyle: TextStyle(fontSize: kSize(11), height: 0.8),
        ),
      ),
    );
  }
}
