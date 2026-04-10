class OrderModel {
  final String title; // طلب خدمة، طلب جديد، إلخ
  final String serviceType; // نقاشة، سباكة
  final String description; // محتاج اشطب شقة...
  final String date; // 15/11/2026
  final String price; // 500 ج للمتر
  final String location; // بور سعيد - حي الزهور

  OrderModel({
    required this.title,
    required this.serviceType,
    required this.description,
    required this.date,
    required this.price,
    required this.location,
  });
}
