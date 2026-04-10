import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_provider_model.dart';

class ServiceProviderCard extends StatelessWidget {
  const ServiceProviderCard({super.key, required this.worker});

  final ServiceProviderModel worker;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ServiceProviderInfoScreen(worker: worker),
        // ),
        //  );
      },
      child: Container(
        width: kWidth(354),
        height: kHeight(179),
        margin: EdgeInsets.symmetric(
          horizontal: kWidth(10),
          vertical: kHeight(8),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kSize(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: kSize(12),
              offset: Offset(0, kHeight(4)),
            ),
          ],
        ),
        padding: EdgeInsets.all(kSize(12)),
        child: Row(
          children: [
            //  الصورة وحالة التوفر والتقييم
            Column(
              children: [
                SizedBox(height: kSize(16)),

                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(kSize(20)),
                      child: Container(
                        width: kWidth(115),
                        height: kHeight(105),
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: kSize(40),
                        ),
                      ),
                    ),
                    // شريط حالة التوفر
                    Container(
                      width: kWidth(115),
                      padding: EdgeInsets.symmetric(vertical: kHeight(4)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(kSize(20)),
                          bottomRight: Radius.circular(kSize(20)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'متاح للعمل',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: kSize(11),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: kWidth(4)),
                          CircleAvatar(
                            radius: kSize(4),
                            backgroundColor: worker.isAvailable
                                ? Colors.green
                                : Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: kHeight(8)),
                // التقييم
                Row(
                  children: [
                    Text(
                      "( 15 ) 4.8",
                      style: TextStyle(
                        fontSize: kSize(14),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: kWidth(4)),
                    Icon(Icons.star, color: Colors.amber, size: kSize(18)),
                  ],
                ),
              ],
            ),

            SizedBox(width: kWidth(15)),

            //  الجزء الأيمن البيانات والأزرار
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // الاسم
                  Text(
                    worker.fullName,
                    style: TextStyle(
                      fontSize: kSize(17),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: kHeight(6)),

                  // المهنة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        worker.profession,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: kSize(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: kWidth(6)),
                      Icon(
                        Icons.construction_outlined,
                        size: kSize(16),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(3)),

                  // الموقع
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        worker.governorate,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: kSize(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: kWidth(6)),
                      Icon(
                        Icons.location_on_outlined,
                        size: kSize(16),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(3)),

                  // مكتمل
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "14 مكتمل",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: kSize(13),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: kWidth(6)),
                      Icon(
                        Icons.check_circle_outline,
                        size: kSize(16),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(3)),

                  // السعر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        worker.pricingType,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: kSize(13),
                        ),
                      ),
                      SizedBox(width: kWidth(6)),
                      Icon(
                        Icons.money_outlined,
                        color: Colors.green,
                        size: kSize(16),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // ا اطلب خدمة + القلب
                  Row(
                    children: [
                      // أيقونة القلب
                      Icon(
                        Icons.favorite_border,
                        color: Colors.grey,
                        size: kSize(24),
                      ),
                      SizedBox(width: kWidth(10)),
                      // زر اطلب خدمة
                      Expanded(
                        child: Container(
                          height: kHeight(38),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5A623),
                            borderRadius: BorderRadius.circular(kSize(12)),
                          ),
                          child: Center(
                            child: Text(
                              'اطلب خدمة',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: kSize(14),
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
      ),
    );
  }
}
