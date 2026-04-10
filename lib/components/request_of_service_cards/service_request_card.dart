import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class ServiceRequestCard extends StatelessWidget {
  final bool isNewRequest;
  final String serviceType;
  final String serviceDescription;
  final String serviceInitDate;
  final String serviceDeuration;
  final String serviceAddress;
  final String serviceInitPrice;

  ServiceRequestCard({
    super.key,
    required this.serviceType,
    required this.serviceDescription,
    required this.serviceInitDate,
    required this.serviceAddress,
    required this.serviceInitPrice,
    required this.isNewRequest,
    required this.serviceDeuration,
  });
  int day = 5;

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
                  isNewRequest ? 'طلب جديد' : 'طلب خدمة',
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
                // type of service
                _buildInfoRow('نوع الخدمة', serviceType),
                SizedBox(height: kHeight(8)),

                // description of service
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        serviceDescription,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: const Color(0xFF838383),
                          fontSize: kSize(14),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      ' : الوصف',
                      style: TextStyle(
                        fontSize: kSize(14),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kHeight(8)),

                // history of service
                _buildInfoRow('التاريخ المبدئي', serviceInitDate),
                SizedBox(height: kHeight(8)),

                // history of service
                _buildInfoRow(
                  'مدة التنفيذ',
                  'يوم',
                  isDuration: true,
                  day: serviceDeuration,
                ),
                SizedBox(height: kHeight(8)),

                // initial price of service
                _buildInfoRow('السعر المبدئي', serviceInitPrice),
                SizedBox(height: kHeight(12)),

                // location of service
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      serviceAddress,
                      style: TextStyle(
                        fontSize: kSize(14),
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.location_on,
                      color: kPrimaryColor,
                      size: kSize(18),
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
                      onPressed: () {},
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
                      onTap: () {},
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
                    if (isNewRequest)
                      GestureDetector(
                        onTap: () {},
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
    bool isDuration = false,
    String? day,
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
        if (isDuration)
          Text(
            ' $day',
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
