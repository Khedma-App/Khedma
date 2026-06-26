import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khedma/core/constants.dart';

class CustomAmountSection extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final double agreedAmount;

  const CustomAmountSection({
    super.key,
    required this.controller,
    this.validator,
    this.agreedAmount = 0.0,
  });

  @override
  State<CustomAmountSection> createState() => _AmountSectionState();
}

class _AmountSectionState extends State<CustomAmountSection> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // حساب القيمة الحالية المدفوعة
    double currentPaid = double.tryParse(widget.controller.text) ?? 0.0;
    bool isCompleted =
        widget.agreedAmount > 0 && currentPaid >= widget.agreedAmount;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kSize(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'المبلغ المدفوع فعلياً',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: kSize(16),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF211B12),
            ),
          ),
          SizedBox(height: kHeight(8)),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.left,
              validator: widget.validator,
              style: TextStyle(fontSize: kSize(14), fontFamily: 'Cairo'),
              decoration: _inputDecoration(hint: '0000 ج'),
            ),
          ),
          SizedBox(height: kHeight(10)),

          if (widget.agreedAmount > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  'المبلغ المتفق عليه في العقد: ${widget.agreedAmount.toInt()} ج',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: kSize(13),
                    color: const Color(0xff514534),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: kWidth(10)),
                Expanded(
                  child: Text(
                    isCompleted
                        ? '✅ اكتمل المبلغ بالكامل'
                        : '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(13),
                      color: isCompleted
                          ? Colors.green[700]
                          : const Color(0xFF00A27A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: kSize(14), color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(
        horizontal: kWidth(16),
        vertical: kHeight(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kSize(12)),
        borderSide: const BorderSide(color: Color(0xFFD6C4AE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kSize(12)),
        borderSide: const BorderSide(color: Color(0xFF00A27A), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kSize(12)),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kSize(12)),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      errorStyle: TextStyle(fontFamily: 'Cairo', fontSize: kSize(12)),
    );
  }
}
