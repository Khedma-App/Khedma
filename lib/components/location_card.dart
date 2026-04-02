import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_data.dart';
import 'package:khedma/screens/auth_screens/service_provider_screen.dart';

class LocationCard extends StatelessWidget {
  final String? selectedGovernorate;
  final String? selectedCity;
  final bool isAvailableOutside;
  final String? selectedFrom;
  final String? selectedTo;
  final Function(String?) onGovernorateChanged;
  final Function(String?) onCityChanged;
  final Function(bool) onAvailableOutsideChanged;
  final Function(String?) onFromTimeChanged;
  final Function(String?) onToTimeChanged;
  final String? governorateError;
  final String? cityError;

  const LocationCard({
    super.key,
    required this.selectedGovernorate,
    required this.selectedCity,
    required this.isAvailableOutside,
    required this.selectedFrom,
    required this.selectedTo,
    required this.onGovernorateChanged,
    required this.onCityChanged,
    required this.onAvailableOutsideChanged,
    required this.onFromTimeChanged,
    required this.onToTimeChanged,
    this.governorateError,
    this.cityError,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle hintStyle = TextStyle(
      fontFamily: 'Cairo',
      fontSize: kSize(10),
      fontWeight: FontWeight.w700,
      color: const Color(0xFF838383),
      height: 1.0,
    );

    final TextStyle errorStyle = TextStyle(
      fontSize: kSize(11),
      color: Colors.red,
      fontWeight: FontWeight.w500,
    );

    return Container(
      padding: EdgeInsets.all(kSize(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kSize(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: kSize(10),
            spreadRadius: kSize(2),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "المحافظة",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: kSize(12),
                      ),
                    ),
                    SizedBox(height: kHeight(8)),
                    Container(
                      height: kHeight(40),
                      width: kWidth(110),
                      padding: EdgeInsets.symmetric(horizontal: kSize(12)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        border: Border.all(
                          color: governorateError != null
                              ? Colors.red
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(kSize(12)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text("المحافظة", style: hintStyle),
                          value: selectedGovernorate,
                          items: EgyptData.egyptData.keys
                              .map(
                                (gov) => DropdownMenuItem(
                                  value: gov,
                                  child: Text(gov),
                                ),
                              )
                              .toList(),
                          onChanged: onGovernorateChanged,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: kWidth(20)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "المنطقة",
                        style: TextStyle(
                          fontSize: kSize(12),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: kHeight(8)),
                      Container(
                        height: kHeight(40),
                        width: kWidth(110),
                        padding: EdgeInsets.symmetric(horizontal: kSize(12)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F6F6),
                          border: Border.all(
                            color: cityError != null
                                ? Colors.red
                                : Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(kSize(12)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Text("المنطقة", style: hintStyle),
                            value: selectedCity,
                            items: selectedGovernorate == null
                                ? []
                                : EgyptData.egyptData[selectedGovernorate]!
                                      .map(
                                        (city) => DropdownMenuItem(
                                          value: city,
                                          child: Text(city),
                                        ),
                                      )
                                      .toList(),
                            onChanged: onCityChanged,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (governorateError != null)
              Padding(
                padding: EdgeInsets.only(top: kHeight(8)),
                child: Text(governorateError!, style: errorStyle),
              ),
            if (cityError != null && selectedGovernorate != null)
              Padding(
                padding: EdgeInsets.only(top: kHeight(8)),
                child: Text(cityError!, style: errorStyle),
              ),
            SizedBox(height: kHeight(5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "متاح للعمل خارج المحافظة",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: kSize(12),
                  ),
                ),
                Checkbox(
                  value: isAvailableOutside,
                  activeColor: Colors.black,
                  onChanged: (val) {
                    if (val != null) onAvailableOutsideChanged(val);
                  },
                ),
              ],
            ),
            SizedBox(height: kHeight(5)),
            Row(
              children: [
                Text(
                  "اوقات العمل ( اختياري )",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: kSize(12),
                  ),
                ),
                SizedBox(width: kWidth(10)),
                _buildTimeDropdown("من", selectedFrom, onFromTimeChanged),
                SizedBox(width: kWidth(10)),
                _buildTimeDropdown("إلى", selectedTo, onToTimeChanged),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDropdown(
    String hint,
    String? value,
    Function(String?) onChanged,
  ) {
    return Container(
      width: kWidth(80),
      height: kHeight(30),
      padding: EdgeInsets.symmetric(horizontal: kSize(8)),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(kSize(20)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hint, style: TextStyle(fontSize: kSize(12))),
          value: value,
          items: List.generate(24, (i) {
            int hour = i + 1;
            String period = hour <= 12 ? "صباحي" : "مسائي";
            int displayHour = hour <= 12 ? hour : hour - 12;
            return DropdownMenuItem(
              value: "$hour",
              child: Text("$displayHour ${period == "صباحي" ? "ص" : "م"}"),
            );
          }),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
