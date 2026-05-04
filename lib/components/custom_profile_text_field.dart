import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomProfileTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool isPassword;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomProfileTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.isPassword = false,
    this.onChanged,
    this.validator,
  });

  @override
  State<CustomProfileTextField> createState() => _CustomProfileTextFieldState();
}

class _CustomProfileTextFieldState extends State<CustomProfileTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kWidth(354),
      margin: EdgeInsets.only(bottom: kHeight(15)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kSize(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        textAlign: TextAlign.right,
        onChanged: widget.onChanged,
        validator: widget.validator,
        style: TextStyle(fontSize: kSize(14), fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          filled: false,
          hintText: widget.hint ?? widget.label,
          hintStyle: TextStyle(
            color: const Color(0x80838383),
            fontSize: kSize(12),
            fontWeight: FontWeight.w700,
          ),
          prefixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFFE19113),
                    size: kSize(20),
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kSize(12)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kSize(12)),
            borderSide: const BorderSide(color: Color(0xFFE19113), width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kSize(12)),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kSize(12)),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: kWidth(20),
            vertical: kHeight(12),
          ),
          errorStyle: TextStyle(fontSize: kSize(11), height: 0.8),
        ),
      ),
    );
  }
}
