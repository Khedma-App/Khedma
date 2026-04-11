import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class EditRequestReceiverCard extends StatelessWidget {
  final String notes;
  final String price;
  final String serviceDeuration;
  final String serviceInitDate;
  VoidCallback? onAccept;
  VoidCallback? onEdit;
  VoidCallback? onCancel;

  EditRequestReceiverCard({
    super.key,
    required this.notes,
    required this.price,
    required this.serviceDeuration,
    required this.serviceInitDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kHeight(304),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: kHeight(34),
            padding: EdgeInsets.symmetric(horizontal: kWidth(12)),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: kPrimaryColor,
              shape: BoxShape.rectangle,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'طلب تعديل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: kSize(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: kWidth(7)),
                Image.asset(
                  'assets/icons/service_of_request_icon.png',
                  width: kSize(20),
                  height: kSize(20),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kWidth(12),
              vertical: kHeight(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: kHeight(8)),

                // history of service
                _buildInfoRow('تاريخ البدء', serviceInitDate),
                SizedBox(height: kHeight(8)),

                // history of service
                _buildInfoRow(
                  'مدة التنفيذ',
                  'يوم',
                  isWithNum: true,
                  num: serviceDeuration,
                ),
                SizedBox(height: kHeight(8)),

                // recommended price of service
                _buildInfoRow(
                  'السعر المقترح',
                  'جنيه',
                  isWithNum: true,
                  num: price,
                ),
                SizedBox(height: kHeight(12)),

                // notes
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notes,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: const Color(0xFF838383),
                          fontSize: kSize(14),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      ' : ملاحظات',
                      style: TextStyle(
                        fontSize: kSize(14),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kHeight(20)),

                // buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // cancel button
                    OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF838383),
                        side: const BorderSide(
                          color: Color(0xFFE89A24),
                          width: 1.5,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: kWidth(27)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'الغاء',
                        style: TextStyle(
                          fontSize: kSize(14),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // edit button
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        height: kHeight(36),
                        width: kWidth(88),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'تعديل',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: kSize(14),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // accept button
                    GestureDetector(
                      onTap: onAccept,
                      child: Container(
                        height: kHeight(36),
                        width: kWidth(88),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(47, 188, 52, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'قبول',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: kSize(14),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isWithNum = false,
    String? num,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF838383),
            fontSize: kSize(14),
            fontWeight: FontWeight.w700,
          ),
        ),
        if (isWithNum)
          Text(
            ' $num',
            style: TextStyle(
              color: const Color(0xFF838383),
              fontSize: kSize(14),
              fontWeight: FontWeight.w700,
            ),
          ),
        Text(
          ' : $label',
          style: TextStyle(fontSize: kSize(14), fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
