import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_item.dart';

class ServiceItem extends StatelessWidget {
  final ServiceModel service;
  const ServiceItem({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: kWidth(16),
        vertical: kHeight(5),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kWidth(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: kWidth(16),
          vertical: kHeight(6),
        ),
        // الأيقونة على اليمين (trailing في RTL)
        leading: Container(
          width: kWidth(48),
          height: kWidth(48),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(kWidth(10)),
          ),
          padding: EdgeInsets.all(kWidth(8)),
          child: Image.asset(service.imagePath, fit: BoxFit.contain),
        ),
        // اسم الخدمة على اليمين
        title: Text(
          service.title,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: kWidth(16),
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        // العدد على اليسار داخل دائرة برتقالية
        trailing: Container(
          width: kWidth(32),
          height: kWidth(32),
          decoration: const BoxDecoration(
            color: Color(0xFFE19113),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            service.count,
            style: TextStyle(
              fontSize: kWidth(13),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
