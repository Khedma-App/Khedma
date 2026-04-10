// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:khedma/components/service_provider_card.dart';
// import 'package:khedma/core/constants.dart';
// import 'package:khedma/models/service_provider_model.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<ServiceProviderModel> ServiceProviders = [
//     ServiceProviderModel(
//       imagesOfPreviousWorks: ['assets/images/service_provider_info_image.png'],
//       fullName: 'احمد علي',
//       profileImageUrl: 'assets/images/naqash.jpg',
//       governorate: 'القاهرة',
//       profession: 'نجار',
//       pricingType: 'بالساعة',
//       isAvailable: true,
//     ),
//     ServiceProviderModel(
//       imagesOfPreviousWorks: ['assets/images/service_provider_info_image.png'],
//       fullName: 'عبدالرحمن عبدالرحمن عبدالرحمن',
//       profileImageUrl: 'assets/images/naqash.jpg',
//       overviewOfExperience:
//           'خبرة 15 سنة في مجال الدهانات بأنواعها خبرة 15 سنة في مجال الدهانات بأنواعها',
//       governorate: 'الاسكندرية',
//       profession: 'حداد',
//       pricingType: 'بالساعة',
//       isAvailable: true,
//     ),
//     ServiceProviderModel(
//       imagesOfPreviousWorks: ['assets/images/service_provider_info_image.png'],
//       fullName: 'محمد محمد',
//       profileImageUrl: 'assets/images/naqash.jpg',
//       governorate: 'اسيوط',
//       profession: 'نجار',
//       pricingType: 'باليومية',
//       isAvailable: false,
//     ),
//     ServiceProviderModel(
//       imagesOfPreviousWorks: ['assets/images/service_provider_info_image.png'],
//       fullName: 'احمد نوبي',
//       profileImageUrl: 'assets/images/naqash.jpg',
//       governorate: 'الاقصر',
//       profession: 'سباك',
//       pricingType: 'بالمتر',
//       isAvailable: true,
//     ),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // Top Section with Background Image
//           Container(
//             height: kHeight(247),
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(40),
//                 bottomRight: Radius.circular(40),
//               ),
//               image: DecorationImage(
//                 image: AssetImage('assets/images/home_background2.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Column(
//               children: [
//                 SizedBox(height: kHeight(47)),
//                 Row(
//                   children: [
//                     Spacer(),
//                     Image.asset('assets/images/logo.png', width: kWidth(115)),
//                     SizedBox(width: kWidth(20)),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Spacer(),
//                     Text(
//                       '! كل الخدمات في جيبك',
//                       style: TextStyle(
//                         shadows: [
//                           Shadow(
//                             offset: Offset(0, 2),
//                             blurRadius: 4,
//                             color: Color.fromRGBO(0, 0, 0, 0.5),
//                           ),
//                         ],
//                         fontSize: kSize(20),
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(width: kWidth(20)),
//                   ],
//                 ),
//                 SizedBox(height: kHeight(25)),
//                 Row(
//                   children: [
//                     SizedBox(width: kWidth(37)),
//                     Text(
//                       'المنطقة الحالية',
//                       style: TextStyle(
//                         fontSize: kSize(16),
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Spacer(),
//                   ],
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: kWidth(15)),
//                   height: kHeight(56),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFEF9B17),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Row(
//                     children: [
//                       SizedBox(width: kWidth(17)),
//                       Text(
//                         'بورسعيد',
//                         style: TextStyle(
//                           fontSize: kSize(16),
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Spacer(),
//                       Image.asset(
//                         'assets/images/location.png',
//                         width: kWidth(24),
//                       ),
//                       Spacer(),
//                       Container(
//                         width: kWidth(246),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(30),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color.fromRGBO(0, 0, 0, 0.25),
//                               blurRadius: 4,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             suffixIcon: Padding(
//                               padding: EdgeInsets.only(
//                                 right: kWidth(12),
//                                 left: kWidth(12),
//                               ),
//                               child: Image.asset(
//                                 'assets/images/search.png',
//                                 width: kWidth(10),
//                               ),
//                             ),
//                             hintText: 'ابحث عن الخدمات الي انت محتاجها',
//                             hintStyle: TextStyle(
//                               fontSize: kSize(11),
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFFBDBDBD),
//                             ),
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.only(
//                               left: kWidth(15),
//                               top: kHeight(18),
//                               bottom: kHeight(18),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: kHeight(15)),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: kWidth(25)),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // Top Ads
//                     Image.asset('assets/images/jotun_ads.jpg'),
//                     SizedBox(height: kHeight(15)),
//                     // Trusted Workers Banner (ads)
//                     Container(
//                       width: kWidth(340),
//                       height: kHeight(46),
//                       decoration: BoxDecoration(
//                         color: Color.fromRGBO(225, 145, 19, 1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(1.0),
//                             child: Image.asset(
//                               'assets/images/check.png',
//                               width: kWidth(40),
//                             ),
//                           ),
//                           Text(
//                             'عمال ذات ثقة وبدون عمولة ',
//                             style: TextStyle(
//                               fontSize: kSize(17),
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: kHeight(15)),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(
//                           'الاقرب لك',
//                           style: TextStyle(
//                             fontSize: kSize(20),
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: kHeight(15)), // مسافة بسيطة للترتيب
//                     // 🔥 بداية الكود الجديد (StreamBuilder) 🔥
//                     StreamBuilder<QuerySnapshot>(
//                       stream: FirebaseFirestore.instance
//                           .collection('users')
//                           .where('role', isEqualTo: 'provider')
//                           .where('profileCompleted', isEqualTo: true)
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         // 1. حالة التحميل
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Padding(
//                             padding: EdgeInsets.symmetric(
//                               vertical: kHeight(20),
//                             ),
//                             child: const Center(
//                               child: CircularProgressIndicator(
//                                 color: Colors.orange,
//                               ),
//                             ),
//                           );
//                         }

//                         // 2. حالة عدم وجود بيانات
//                         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                           return Padding(
//                             padding: EdgeInsets.symmetric(
//                               vertical: kHeight(20),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'لا يوجد مقدمي خدمة في الوقت الحالي',
//                                 style: TextStyle(
//                                   fontSize: kSize(16),
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }

//                         // 3. استخراج البيانات
//                         final providerDocs = snapshot.data!.docs;

//                         // 4. بناء القائمة
//                         return ListView.builder(
//                           itemCount: providerDocs.length,
//                           shrinkWrap:
//                               true, // 👈 مهم جداً ليعمل داخل SingleChildScrollView
//                           physics:
//                               const NeverScrollableScrollPhysics(), // 👈 يمنع تداخل السحب
//                           itemBuilder: (context, index) {
//                             var doc =
//                                 providerDocs[index].data()
//                                     as Map<String, dynamic>;

//                             // تحويل Map إلى Model
//                             ServiceProviderModel worker =
//                                 ServiceProviderModel.fromMap(
//                                   doc['providerData'],
//                                 );

//                             // عرض الكارد الخاص بك
//                             return Padding(
//                               padding: const EdgeInsets.only(
//                                 bottom: 15.0,
//                               ), // مسافة بين الكروت
//                               child: ServiceProviderCard(worker: worker),
//                             );
//                           },
//                         );
//                       },
//                     ),

//                     // 🔥 نهاية الكود الجديد 🔥
//                     SizedBox(height: kHeight(30)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:khedma/components/service_provider_card.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_provider_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 🔥 متغير لحفظ اسم المنطقة (يبدأ بكلمة جاري التحديد)
  String currentLocation = 'جاري التحديد...';

  @override
  void initState() {
    super.initState();
    // جلب الموقع بمجرد فتح الشاشة
    setState(() {
      _getUserLocation(); // 🔥 استدعاء الدالة لتحديد الموقع عند بدء الشاشة
    });
  }

  // 🔥 دالة تحديد الموقع باستخدام الـ GPS
  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // 1. فحص هل الـ GPS يعمل
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => currentLocation = 'الـ GPS مغلق');
        return;
      }

      // 2. فحص الصلاحيات
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() => currentLocation = 'صلاحية مرفوضة');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => currentLocation = 'صلاحية مرفوضة دائماً');
        return;
      }

      // 3. جلب الإحداثيات الدقيقة
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4. تحويل الإحداثيات لاسم المنطقة
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (mounted) {
          setState(() {
            // نأخذ اسم المحافظة أو المنطقة
            currentLocation =
                place.administrativeArea ??
                place.locality ??
                'منطقة غير معروفة';
          });
        }
      }
    } catch (e) {
      print("Error fetching location: $e");
      if (mounted) setState(() => currentLocation = 'غير معروف');
    }
  }

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
            decoration: const BoxDecoration(
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
                    const Spacer(),
                    Image.asset('assets/images/logo.png', width: kWidth(115)),
                    SizedBox(width: kWidth(20)),
                  ],
                ),
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      '! كل الخدمات في جيبك',
                      style: TextStyle(
                        shadows: const [
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
                    const Spacer(),
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
                      SizedBox(width: kWidth(15)),
                      // 🔥 عرض الموقع الحالي بنجاح
                      Expanded(
                        child: Text(
                          currentLocation,
                          style: TextStyle(
                            fontSize: kSize(14),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // لضمان عدم خروج النص لو كان طويلاً
                        ),
                      ),
                      SizedBox(width: kWidth(5)),
                      Image.asset(
                        'assets/images/location.png',
                        width: kWidth(24),
                      ),
                      SizedBox(width: kWidth(10)),
                      // شريط البحث
                      Container(
                        width: kWidth(220), // تصغير بسيط ليناسب اسم الموقع
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
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
                              color: const Color(0xFFBDBDBD),
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
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Image.asset('assets/images/jotun_ads.jpg'),
                    SizedBox(height: kHeight(15)),
                    Container(
                      width: kWidth(340),
                      height: kHeight(46),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(225, 145, 19, 1),
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
                    SizedBox(height: kHeight(15)),

                    // Firebase Stream Builder
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'provider')
                          .where('profileCompleted', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: kHeight(20),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: kHeight(20),
                            ),
                            child: Center(
                              child: Text(
                                'لا يوجد مقدمي خدمة في الوقت الحالي',
                                style: TextStyle(
                                  fontSize: kSize(16),
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }

                        final providerDocs = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: providerDocs.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var doc =
                                providerDocs[index].data()
                                    as Map<String, dynamic>;

                            ServiceProviderModel worker =
                                ServiceProviderModel.fromMap(
                                  doc['providerData'],
                                  documentId: providerDocs[index].id,
                                );

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: ServiceProviderCard(worker: worker),
                            );
                          },
                        );
                      },
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
