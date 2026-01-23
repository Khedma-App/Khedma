import 'package:flutter/material.dart';
import 'package:khedma/components/service_provider_card.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_provider_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ServiceProviderModel> ServiceProviders = [
    ServiceProviderModel(
      fullName: 'احمد علي',
      profileImageUrl: 'assets/images/naqash.jpg',
      governorate: 'القاهرة',
      profession: 'نجار',
      pricingType: 'بالساعة',
      isAvailable: true,
    ),
    ServiceProviderModel(
      fullName: 'محمد محمد',
      profileImageUrl: 'assets/images/naqash.jpg',
      governorate: 'اسيوط',
      profession: 'نجار',
      pricingType: 'باليومية',
      isAvailable: false,
    ),
    ServiceProviderModel(
      fullName: 'احمد نوبي',
      profileImageUrl: 'assets/images/naqash.jpg',
      governorate: 'الاقصر',
      profession: 'سباك',
      pricingType: 'بالمتر',
      isAvailable: true,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Section with Background Image
          Container(
            height: kHeight(247),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/home_background2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: kHeight(47)),
                Row(
                  children: [
                    Spacer(),
                    Image.asset('assets/images/logo.png', width: kWidth(115)),
                    SizedBox(width: kWidth(20)),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      '! كل الخدمات في جيبك',
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ],
                        fontSize: kSize(20),
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: kWidth(20)),
                  ],
                ),
                SizedBox(height: kHeight(25)),
                Row(
                  children: [
                    SizedBox(width: kWidth(37)),
                    Text(
                      'المنطقة الحالية',
                      style: TextStyle(
                        fontSize: kSize(16),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: kWidth(15)),
                  height: kHeight(56),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF9B17),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: kWidth(17)),
                      Text(
                        'بورسعيد',
                        style: TextStyle(
                          fontSize: kSize(16),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      Image.asset(
                        'assets/images/location.png',
                        width: kWidth(24),
                      ),
                      Spacer(),
                      Container(
                        width: kWidth(246),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.25),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(
                                right: kWidth(12),
                                left: kWidth(12),
                              ),
                              child: Image.asset(
                                'assets/images/search.png',
                                width: kWidth(10),
                              ),
                            ),
                            hintText: 'ابحث عن الخدمات الي انت محتاجها',
                            hintStyle: TextStyle(
                              fontSize: kSize(11),
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFBDBDBD),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              left: kWidth(15),
                              top: kHeight(18),
                              bottom: kHeight(18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kHeight(15)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: kWidth(25)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset('assets/images/jotun_ads.jpg'),
                    SizedBox(height: kHeight(15)),
                    Container(
                      width: kWidth(340),
                      height: kHeight(46),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(225, 145, 19, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Image.asset(
                              'assets/images/check.png',
                              width: kWidth(40),
                            ),
                          ),
                          Text(
                            'عمال ذات ثقة وبدون عمولة ',
                            style: TextStyle(
                              fontSize: kSize(17),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: kHeight(15)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'الاقرب لك',
                          style: TextStyle(
                            fontSize: kSize(20),
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    ListView.builder(
                      itemCount: ServiceProviders.length,
                      itemBuilder: (context, index) {
                        final worker = ServiceProviders[index];
                        return ServiceProviderCard(worker: worker);
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                    SizedBox(height: kHeight(30)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
