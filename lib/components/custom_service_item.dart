import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_item.dart';
import 'package:khedma/screens/service_sections_screen.dart';

class ServiceItem extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;

  const ServiceItem({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: kHeight(15)),
        child: InkWell(
          onTap:
              onTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ServiceSectionsScreen()),
                );
              },
          borderRadius: BorderRadius.circular(19),
          child: Container(
            width: kWidth(354),
            height: kHeight(60),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: kWidth(20)),
              child: Row(
                children: [
                  // دائرة العدد
                  Container(
                    width: kWidth(35),
                    height: kWidth(35),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE19113),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      service.count,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: kWidth(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // اسم الخدمة
                  Text(
                    service.title,
                    style: TextStyle(
                      fontSize: kWidth(18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: kWidth(12)),
                  // أيقونة الخدمة
                  Image.asset(
                    service.imagePath,
                    width: kWidth(35),
                    height: kWidth(35),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
