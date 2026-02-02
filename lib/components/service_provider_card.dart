import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_provider_model.dart';
import 'package:khedma/screens/service_provider_info_screen.dart';

class ServiceProviderCard extends StatelessWidget {
  const ServiceProviderCard({super.key, required this.worker});

  final ServiceProviderModel worker;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceProviderInfoScreen(worker: worker),
          ),
        );
      },
      child: Container(
        width: kWidth(329),
        height: kHeight(160),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: kWidth(5),
          vertical: kHeight(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  worker.profileImageUrl,
                  width: kWidth(151),
                  height: kHeight(151),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: kWidth(10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          textDirection: TextDirection.rtl,
                          worker.fullName,
                          style: TextStyle(
                            fontSize: kSize(15),
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          textDirection: TextDirection.rtl,
                          worker.governorate,
                          style: TextStyle(
                            fontSize: kSize(14),
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: kWidth(3)),
                      Image.asset(
                        'assets/images/location2.png',
                        width: kWidth(18),
                      ),
                      SizedBox(width: kWidth(8)),
                      Text(
                        worker.profession,
                        style: TextStyle(
                          fontSize: kSize(14),
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: kWidth(3)),
                      Image.asset(
                        'assets/images/worker.png',
                        width: kWidth(18),
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        worker.pricingType,
                        style: TextStyle(
                          fontSize: kSize(14),
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: kWidth(3)),
                      Image.asset(
                        'assets/images/pricing.png',
                        width: kWidth(18),
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        worker.isAvailable ? 'متاح للعمل' : 'غير متاح للعمل',
                        style: TextStyle(
                          fontSize: kSize(14),
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: kWidth(5)),
                      Container(
                        width: kWidth(16),
                        height: kHeight(16),
                        decoration: BoxDecoration(
                          color: worker.isAvailable
                              ? Color.fromRGBO(47, 188, 52, 1)
                              : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: kHeight(10)),
                    width: kWidth(100),
                    height: kHeight(33),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(239, 155, 23, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'تواصل',
                        style: TextStyle(
                          fontSize: kSize(15),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: kWidth(10)),
          ],
        ),
      ),
    );
  }
}
