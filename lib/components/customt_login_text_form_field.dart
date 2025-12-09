import 'package:flutter/material.dart';

class CustomLoginTextFormField extends StatelessWidget {
  const CustomLoginTextFormField({
    super.key,
    required this.hint,
    this.obscureText = false,
    this.validator,
    this.controller,
    this.width,
    // this.widget,
  });

  final String hint;
  // final Widget? widget;
  final double? width;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      width: width,
      // height: height,
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        textAlign: TextAlign.left,
        enabled: true,
        decoration: InputDecoration(
          // helperText: ' ',
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),

          hint: Align(
            alignment: Alignment.centerRight,
            child: Text(
              hint,
              style: TextStyle(
                color: Color(0x83838380),
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          alignLabelWithHint: true,
          hintTextDirection: TextDirection.rtl,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange, width: 1.5),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
