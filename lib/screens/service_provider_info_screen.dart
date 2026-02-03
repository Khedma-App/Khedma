import 'package:flutter/material.dart';
import 'package:khedma/components/Images_slider_of_previous_works.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_provider_model.dart';
import 'package:khedma/screens/main_layout_screen.dart';

class ServiceProviderInfoScreen extends StatelessWidget {
  const ServiceProviderInfoScreen({super.key, required this.worker});
  final ServiceProviderModel worker;

  static String id = 'service_provider_info_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gallery of previous works
            Stack(
              children: [
                ImagesSliderOfPreviousWorks(
                  images: worker.imagesOfPreviousWorks,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          height: kHeight(40),
                          width: kWidth(40),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(131, 131, 131, 0.5),
                          ),
                          child: Image.asset('assets/images/arrow_back2.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: kWidth(12)),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(11),
                    width: double.infinity,
                    // height: kHeight(108),
                    // constraints: BoxConstraints(minHeight: kHeight(30)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: kWidth(28)),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: kHeight(25),
                              width: kWidth(25),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: worker.isAvailable
                                      ? Color.fromRGBO(47, 188, 52, 1)
                                      : Colors.red,
                                  width: 25,
                                ),
                              ),
                            ),
                            // name
                            Expanded(
                              child: Text(
                                textDirection: TextDirection.rtl,

                                worker.fullName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: kWidth(16)),
                            // profile image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                worker.profileImageUrl,
                                height: kHeight(50),
                                width: kWidth(50),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: kHeight(6)),
                        // overview of experience
                        (worker.overviewOfExperience != null)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      worker.overviewOfExperience ?? '',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: kSize(16),
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(height: kHeight(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // governorate
                      Container(
                        width: kWidth(150),
                        // height: kHeight(90),
                        constraints: BoxConstraints(minHeight: kHeight(90)),
                        padding: EdgeInsets.symmetric(
                          horizontal: kWidth(13),
                          vertical: kHeight(9),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'المحافظة',
                                  style: TextStyle(
                                    fontSize: kSize(15),
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(131, 131, 131, 1),
                                  ),
                                ),
                                SizedBox(width: kWidth(5)),
                                Image.asset(
                                  'assets/images/location2.png',
                                  width: kWidth(25),
                                ),
                              ],
                            ),
                            SizedBox(height: kHeight(2)),
                            Text(
                              worker.governorate,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: kSize(20),
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // profession
                      Container(
                        width: kWidth(150),
                        // height: kHeight(90),
                        constraints: BoxConstraints(minHeight: kHeight(90)),
                        padding: EdgeInsets.symmetric(
                          horizontal: kWidth(13),
                          vertical: kHeight(9),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'الحِرفه',
                                  style: TextStyle(
                                    fontSize: kSize(15),
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(131, 131, 131, 1),
                                  ),
                                ),
                                SizedBox(width: kWidth(5)),
                                Image.asset(
                                  'assets/images/worker.png',
                                  width: kWidth(25),
                                ),
                              ],
                            ),
                            SizedBox(height: kHeight(2)),
                            Text(
                              worker.profession,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: kSize(20),
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // emergency works
                      Container(
                        width: kWidth(150),
                        // height: kHeight(90),
                        constraints: BoxConstraints(minHeight: kHeight(90)),
                        padding: EdgeInsets.symmetric(
                          horizontal: kWidth(6),
                          vertical: kHeight(9),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'الاعمال الضرورية',
                                  style: TextStyle(
                                    fontSize: kSize(14),
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(131, 131, 131, 1),
                                  ),
                                ),
                                SizedBox(width: kWidth(3)),
                                Image.asset(
                                  'assets/images/important_works.png',
                                  width: kWidth(25),
                                ),
                              ],
                            ),
                            SizedBox(height: kHeight(2)),
                            Text(
                              (worker.emergencyworks ?? false)
                                  ? 'متاح'
                                  : 'غير متاح',
                              style: TextStyle(
                                fontSize: kSize(20),
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // pricing type
                      Container(
                        width: kWidth(150),
                        // height: kHeight(90),
                        constraints: BoxConstraints(minHeight: kHeight(90)),
                        padding: EdgeInsets.symmetric(
                          horizontal: kWidth(13),
                          vertical: kHeight(9),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'الحساب',
                                  style: TextStyle(
                                    fontSize: kSize(15),
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(131, 131, 131, 1),
                                  ),
                                ),
                                SizedBox(width: kWidth(5)),
                                Image.asset(
                                  'assets/images/type_pricing.png',
                                  width: kWidth(25),
                                ),
                              ],
                            ),
                            SizedBox(height: kHeight(2)),
                            Text(
                              worker.pricingType,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: kSize(20),
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: kHeight(16)),
                  Row(
                    children: [
                      SizedBox(width: kWidth(16)),
                      Container(
                        height: kHeight(27),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            (worker.canWorkOutsideGovernorate ?? false)
                                ? 'متاح'
                                : 'غير متاح',
                            style: TextStyle(
                              fontSize: kSize(16),
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.end,
                          'العمل خارج نطاق المحافظة',
                          style: TextStyle(
                            fontSize: kSize(16),
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(16)),
                    ],
                  ),
                  SizedBox(height: kHeight(40)),
                  // contact button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainLayoutScreen(
                            initialIndex: 1,
                            // targetChatUser: worker,   // هنا هتبعت بيانات العامل اللي عايز تكلمه
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      height: kHeight(60),
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: kWidth(30)),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          'تواصل',
                          style: TextStyle(
                            fontSize: kSize(23),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: kHeight(34)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
