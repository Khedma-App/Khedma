import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khedma/core/constants.dart';

class CustomDateSection extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const CustomDateSection({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<CustomDateSection> createState() => _DateSectionState();
}

class _DateSectionState extends State<CustomDateSection> {
  // دالة اختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF2A93B),
              onPrimary: Colors.white,
              onSurface: Color(0xFF211B12),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != widget.selectedDate) {
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(
      'dd MMMM yyyy',
    ).format(widget.selectedDate);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kSize(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'تاريخ الدفع',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: kSize(16),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF211B12),
            ),
          ),
          SizedBox(height: kHeight(8)),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              height: kHeight(56),
              padding: EdgeInsets.symmetric(horizontal: kWidth(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kSize(12)),
                border: Border.all(color: const Color(0xFFD6C4AE)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: const Color(0xFF514534),
                    size: kSize(24),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(16),
                      color: const Color(0xFF211B12),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
