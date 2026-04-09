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
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Slider Section
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
                          decoration: const BoxDecoration(
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
              padding: EdgeInsets.symmetric(horizontal: kWidth(12)),
              child: Column(
                children: [
                  // Profile Info Card
                  Container(
                    padding: const EdgeInsets.all(11),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Availability Indicator
                            Container(
                              height: kHeight(15),
                              width: kWidth(15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: worker.isAvailable
                                    ? const Color.fromRGBO(47, 188, 52, 1)
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Name
                            Expanded(
                              child: Text(
                                worker.fullName,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: kWidth(16)),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                worker.profileImageUrl,
                                height: kHeight(55),
                                width: kWidth(55),
                                fit: BoxFit.cover,
                                // معالجة حالة التحميل
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: kHeight(55),
                                        width: kWidth(55),
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      );
                                    },
                                // معالجة حالة الخطأ في الرابط
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: kHeight(55),
                                      width: kWidth(55),
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.person,
                                        color: Color.fromARGB(255, 112, 17, 17),
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),

                        // Overview of Experience
                        if (worker.overviewOfExperience != null) ...[
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  worker.overviewOfExperience!,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: kSize(16),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: kHeight(12)),

                  // Governorate & Profession Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoCard(
                        'المحافظة',
                        worker.governorate,
                        'assets/images/location2.png',
                      ),
                      _buildInfoCard(
                        'الحِرفه',
                        worker.profession,
                        'assets/images/worker.png',
                      ),
                    ],
                  ),

                  SizedBox(height: kHeight(12)),

                  // Emergency & Pricing Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoCard(
                        'الاعمال الضرورية',
                        (worker.emergencyworks ?? false) ? 'متاح' : 'غير متاح',
                        'assets/images/important_works.png',
                      ),
                      _buildInfoCard(
                        'الحساب',
                        worker.pricingType,
                        'assets/images/type_pricing.png',
                      ),
                    ],
                  ),

                  SizedBox(height: kHeight(16)),

                  // Work Outside Governorate
                  Row(
                    children: [
                      SizedBox(width: kWidth(16)),
                      Container(
                        height: kHeight(27),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              fontSize: kSize(14),
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          textAlign: TextAlign.end,
                          'العمل خارج نطاق المحافظة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(16)),
                    ],
                  ),

                  SizedBox(height: kHeight(40)),

                  // Contact Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MainLayoutScreen(initialIndex: 1),
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

  // Helper method to build info cards and reduce code duplication
  // 1. تحديث الدالة المساعدة لضمان ثبات الأبعاد
  Widget _buildInfoCard(String title, String value, String iconPath) {
    return Container(
      width: kWidth(155), // تحديد عرض ثابت لمنع التداخل
      padding: EdgeInsets.symmetric(
        horizontal: kWidth(10),
        vertical: kHeight(12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // مهم جداً لمنع تمدد الـ Column لا نهائياً
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: kSize(13),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 6),
              Image.asset(
                iconPath,
                width: kWidth(22),
                height: kHeight(22),
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // استخدام الـ Center أو Align لضمان تموضع النص بشكل صحيح
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: kSize(18),
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
