import 'dart:ui';

class OrderModel {
  final String title;
  final String price;
  final String status;
  final String details;
  final Color statusColor;
  final bool showStars; // لو true يعرض نجوم، لو false يعرض نص
  final String? bottomText; // النص اللي بيظهر تحت لو مفيش نجوم

  OrderModel({
    required this.title,
    required this.price,
    required this.status,
    required this.details,
    required this.statusColor,
    this.showStars = false,
    this.bottomText,
  });
}
