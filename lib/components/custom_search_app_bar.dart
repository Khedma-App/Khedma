import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomSearchAppBar extends StatelessWidget {
  const CustomSearchAppBar({super.key, this.onChanged});
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE19113),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kHeight(5),
        bottom: kHeight(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kWidth(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Image.asset(
                  "assets/images/logo.png",
                  height: kHeight(45),
                  fit: BoxFit.contain,
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: kWidth(22),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          SizedBox(height: kHeight(10)),
          Center(
            child: Container(
              width: kWidth(354),
              height: kHeight(50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19),
              ),
              child: TextField(
                onChanged: onChanged,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.black, fontSize: kWidth(14)),
                decoration: InputDecoration(
                  hintText: 'ابحث عن الخدمات الي انت محتاجها',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: kWidth(13),
                  ),
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFFE19113),
                    size: kWidth(25),
                  ),
                  contentPadding: EdgeInsets.only(
                    right: kWidth(15),
                    top: kHeight(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
