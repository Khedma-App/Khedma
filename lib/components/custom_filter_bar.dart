import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomFilterBar extends StatefulWidget {
  const CustomFilterBar({super.key});

  @override
  State<CustomFilterBar> createState() => _CustomFilterBarState();
}

class _CustomFilterBarState extends State<CustomFilterBar> {
  String selectedArea = "المنطقة";
  String selectedCity = "المحافظة";
  String selectedCraft = "كل الحِـرف";

  int activeIndex = 2; // "كل الحرف" مختار افتراضياً

  final List<String> cities = [
    "القاهرة",
    "الجيزة",
    "الإسكندرية",
    "القليوبية",
    "المنصورة",
    "طنطا",
  ];
  final List<String> areas = [
    "مدينة نصر",
    "مصر الجديدة",
    "المعادي",
    "الدقي",
    "المهندسين",
    "شبرا",
  ];
  final List<String> crafts = [
    "سباك",
    "كهربائي",
    "نقاش",
    "نجار",
    "فني تكييف",
    "كل الحرف",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: kHeight(10),
        horizontal: kWidth(10),
      ),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDropdownFilter(
            title: selectedArea,
            items: areas,
            index: 0,
            onSelected: (val) {
              setState(() {
                selectedArea = val;
                activeIndex = 0;
              });
            },
          ),
          _buildDropdownFilter(
            title: selectedCity,
            items: cities,
            index: 1,
            onSelected: (val) {
              setState(() {
                selectedCity = val;
                activeIndex = 1;
              });
            },
          ),
          _buildDropdownFilter(
            title: selectedCraft,
            items: crafts,
            index: 2,
            onSelected: (val) {
              setState(() {
                selectedCraft = val;
                activeIndex = 2;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String title,
    required List<String> items,
    required int index,
    required Function(String) onSelected,
  }) {
    bool isSelected = activeIndex == index;

    return PopupMenuButton<String>(
      onSelected: onSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) => items.map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(item, style: TextStyle(fontSize: kWidth(13))),
          ),
        );
      }).toList(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: kWidth(115),
        height: kHeight(36),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE19113) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE19113), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_drop_down,
              size: kWidth(30),
              color: const Color.fromARGB(255, 48, 42, 42),
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontSize: kWidth(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
