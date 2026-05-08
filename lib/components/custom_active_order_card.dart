import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

class CustomActiveOrderCard extends StatelessWidget {
  const CustomActiveOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kSize(285),
      margin: EdgeInsets.symmetric(
        horizontal: kSize(18),
        vertical: kHeight(10),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(kSize(9.58)),
        border: Border.all(
          color: const Color(0xFFE8A020).withOpacity(0.30),
          width: kSize(0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFEF3C7).withOpacity(0.08),
            blurRadius: kSize(15.96),
            offset: Offset(0, kHeight(3.19)),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: kSize(12),
              vertical: kHeight(10),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kSize(9.58)),
                topRight: Radius.circular(kSize(9.58)),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: kSize(20),
                  color: Color(0xFF915F2D),
                ),
                SizedBox(width: kSize(6)),
                Expanded(
                  child: Text(
                    "العميل طلب إنهاء العمل — اضغط للتأكيد",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(11.5),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF915F2D),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: kSize(15),
                  color: Color(0xFF915F2D),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(kSize(16)),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "تشطيب شقة 95 متر ",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: kSize(15),
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF2D2D2D),
                            ),
                          ),
                          SizedBox(height: kHeight(4)),
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                size: 14,
                                color: Colors.grey,
                              ),
                              SizedBox(width: kSize(4)),
                              Text(
                                "محمد السعيد",
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: kSize(11),
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: kSize(8)),
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Colors.grey,
                              ),
                              SizedBox(width: kSize(4)),
                              Flexible(
                                child: Text(
                                  "بورسعيد",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: kSize(11),
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: kSize(10)),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "1,500 ",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: kSize(17),
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFFE19113),
                                ),
                              ),
                              TextSpan(
                                text: "ج",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: kSize(12),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE19113),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "KH-2026-00847 :عقد",
                          style: TextStyle(
                            fontSize: kSize(9),
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: kHeight(22)),

                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(kSize(10)),
                        onTap: () {},
                        child: Container(
                          height: kHeight(46),
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669),
                            borderRadius: BorderRadius.circular(kSize(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "تأكيد إنهاء العمل",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Colors.white,
                                  fontSize: kSize(13),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: kSize(8)),
                              const Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 19,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: kSize(10)),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(kSize(10)),
                        onTap: () {},
                        child: Container(
                          height: kHeight(46),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kSize(10)),
                            border: Border.all(
                              color: const Color(0xFFE8A020).withOpacity(0.3),
                              width: kSize(0.8),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "عرض التفاصيل",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
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
}
