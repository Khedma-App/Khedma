import 'package:flutter/material.dart';

class CustomLoginTextFormField extends StatelessWidget {
  const CustomLoginTextFormField({
    super.key,
    required this.hint,
    this.obscureText = false,
    this.validator,
    this.controller,
    this.width,
    this.hight,
    this.isCenter = false,
    this.icon,
    this.useEnabledColor = false,
    required TextInputType keyboardType,
  });

  final String hint;
  final double? width;
  final double? hight;
  final Widget? icon;
  final bool isCenter;
  final bool useEnabledColor;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: hight,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,

        textAlign: TextAlign.right,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,

          contentPadding: const EdgeInsets.symmetric(horizontal: 20),

          // labelText: hint,
          hint: Align(
            alignment: (isCenter) ? Alignment.center : Alignment.centerRight,
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
          prefixIcon: icon,
          labelStyle: const TextStyle(
            color: Color(0xFF838383),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),

          floatingLabelStyle: const TextStyle(
            color: Colors.orange,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: (useEnabledColor) ? Colors.orange : Colors.transparent,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
