import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class AddressDetailsCard extends StatelessWidget {
  final String mainAddress;
  final String detailsAddress;
  final VoidCallback? onShowLocation;

  const AddressDetailsCard({
    super.key,
    required this.mainAddress,
    required this.detailsAddress,
    this.onShowLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kWidth(304),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: kHeight(40),
            padding: EdgeInsets.symmetric(horizontal: kWidth(12)),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: kPrimaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'العنوان بالتفاصيل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: kSize(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: kWidth(8)),
                Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                  size: kSize(24),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kWidth(16),
              vertical: kHeight(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // main address
                Text(
                  mainAddress,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: kSize(16),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: kHeight(10)),

                // detailed address
                Text(
                  detailsAddress,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: kSize(16),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: kHeight(24)),

                // show location button
                Center(
                  child: SizedBox(
                    width: kWidth(180),
                    height: kHeight(40),
                    child: ElevatedButton(
                      onPressed: onShowLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE89A24),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'اظهار الموقع',
                        style: TextStyle(
                          fontSize: kSize(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
