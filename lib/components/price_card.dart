import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class PriceCard extends StatelessWidget {
  final String? selectedPriceOption;
  final Function(String) onPriceOptionChanged;
  final String? priceOptionError;

  const PriceCard({
    super.key,
    required this.selectedPriceOption,
    required this.onPriceOptionChanged,
    this.priceOptionError,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle errorStyle = TextStyle(
      fontSize: kSize(11),
      color: Colors.red,
      fontWeight: FontWeight.w500,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: kSize(20), vertical: kSize(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kSize(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: kSize(10),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: kSize(15)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPriceOption(
                        "السعر حسب المعاينة",
                        selectedPriceOption == "السعر حسب المعاينة",
                      ),
                      SizedBox(height: kHeight(12)),
                      _buildPriceOption(
                        "السعر حسب المساحة",
                        selectedPriceOption == "السعر حسب المساحة",
                      ),
                      SizedBox(height: kHeight(12)),
                      _buildPriceOption(
                        "السعر حسب نوع الخدمة",
                        selectedPriceOption == "السعر حسب نوع الخدمة",
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPriceOption(
                        "بالإتفاق",
                        selectedPriceOption == "بالإتفاق",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (priceOptionError != null)
            Padding(
              padding: EdgeInsets.only(top: kHeight(12)),
              child: Text(priceOptionError!, style: errorStyle),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceOption(String title, bool isSelected) {
    return GestureDetector(
      onTap: () => onPriceOptionChanged(title),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          SizedBox(
            height: kHeight(24),
            width: kWidth(24),
            child: Checkbox(
              value: isSelected,
              onChanged: (val) => onPriceOptionChanged(title),
              activeColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kSize(4)),
              ),
            ),
          ),
          SizedBox(width: kWidth(8)),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: kSize(13),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
