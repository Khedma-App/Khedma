import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomAvailabilityCard extends StatefulWidget {
  const CustomAvailabilityCard({super.key});

  @override
  State<CustomAvailabilityCard> createState() => _AvailabilityCardState();
}

class _AvailabilityCardState extends State<CustomAvailabilityCard> {
  bool isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kSize(354),
      height: kHeight(58),
      margin: EdgeInsets.symmetric(
        horizontal: kSize(18),
        vertical: kHeight(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: kSize(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(kSize(12)),
        border: Border.all(color: const Color(0xFFEEE0D3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: kSize(10),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Transform.scale(
            scale: 1.0,
            child: Switch(
              value: isAvailable,
              activeColor: const Color(0xFF1DBF73),
              onChanged: (value) {
                setState(() {
                  isAvailable = value;
                });
              },
            ),
          ),
          SizedBox(width: kWidth(20)),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F9F1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: isAvailable ? const Color(0xFF1DBF73) : Colors.grey,
              size: kSize(20),
            ),
          ),
          const Spacer(),

          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "متاح للعمل",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(16),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF404040),
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: kHeight(5)),
                  Text(
                    isAvailable
                        ? "أنت تظهر للعملاء الآن"
                        : "أنت مختفٍ عن العملاء",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(12),
                      color: Color(0xff5F5E5B),
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(width: kSize(12)),
            ],
          ),
        ],
      ),
    );
  }
}
