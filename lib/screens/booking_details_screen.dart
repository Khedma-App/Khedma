import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:khedma/components/custom_text_filed_boking.dart';
import 'package:khedma/components/service_provider_card.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_data.dart';
import 'package:khedma/models/service_provider_model.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});
  static const String id = 'bookingdetailsscreen';
  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  //  States
  String? selectedDate;
  String? selectedPricingUnit;
  final TextEditingController _priceController = TextEditingController();

  String? selectedGovernorate;
  String? selectedCity;

  final TextEditingController _addressDetailController =
      TextEditingController();
  final TextEditingController _serviceDescriptionController =
      TextEditingController();

  final ServiceProviderModel sampleWorker = ServiceProviderModel(
    fullName: "محمود سمير",
    profession: "نقاش",
    governorate: "بور سعيد",
    profileImageUrl: "",
    pricingType: "السعر حسب المساحة",
    isAvailable: true,
    imagesOfPreviousWorks: [],
  );

  //  GPS Logic
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('يرجى تفعيل الـ GPS في الهاتف');
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    Position position = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    _showSnackBar(
      'تم تحديد الموقع: ${position.latitude}, ${position.longitude}',
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontFamily: 'Cairo', fontSize: kSize(14)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _addressDetailController.dispose();
    _serviceDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: kHeight(80)),

            //العنوان العلوي للشاشة
            Center(
              child: Text(
                'طلب خدمة',
                style: TextStyle(
                  fontSize: kSize(20),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(height: kHeight(25)),
            ServiceProviderCard(worker: sampleWorker),
            SizedBox(height: kHeight(15)),

            // قسم وصف الخدمة المطلوبة
            Container(
              width: kWidth(354),
              padding: EdgeInsets.all(kSize(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kSize(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, kHeight(2)),
                    blurRadius: kSize(4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'وصف الخدمة',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: kHeight(10)),
                  Custom_Text_Field_Booking_Screen(
                    hintText: 'نوع الخدمة المطلوبة',
                    controller: _serviceDescriptionController,
                    width: 220,
                  ),
                ],
              ),
            ),

            SizedBox(height: kHeight(15)),

            //  قسم تفاصيل العنوان (المحافظة، المنطقة، والتفاصيل)
            Container(
              width: kWidth(354),
              padding: EdgeInsets.all(kSize(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kSize(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: kSize(10),
                    offset: Offset(0, kHeight(4)),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'العنوان',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: kHeight(15)),

                  // صف يحتوي على اختيار المنطقة والمحافظة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // دروب داون اختيار المنطقة
                      Container(
                        width: kWidth(110),
                        height: kHeight(35),
                        padding: EdgeInsets.symmetric(horizontal: kWidth(8)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          border: Border.all(
                            color: const Color(0xFFD1D1D1),
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.circular(kSize(12)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              icon: Icon(
                                Icons.arrow_drop_down_rounded,
                                color: const Color(0xFF424242),
                                size: kSize(24),
                              ),
                              hint: Text(
                                "المنطقة",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: kSize(12),
                                  color: const Color(0xFF838383),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: selectedCity,
                              items:
                                  (selectedGovernorate == null
                                          ? <String>[]
                                          : EgyptData
                                                .egyptData[selectedGovernorate]!)
                                      .map(
                                        (String value) =>
                                            DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: kSize(11),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                      )
                                      .toList(),
                              onChanged: (val) =>
                                  setState(() => selectedCity = val),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(10)),
                      // دروب داون اختيار المحافظة
                      Container(
                        width: kWidth(110),
                        height: kHeight(35),
                        padding: EdgeInsets.symmetric(horizontal: kWidth(8)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          border: Border.all(
                            color: const Color(0xFFD1D1D1),
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.circular(kSize(12)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              icon: Icon(
                                Icons.arrow_drop_down_rounded,
                                color: const Color(0xFF424242),
                                size: kSize(24),
                              ),
                              hint: Text(
                                "المحافظة",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: kSize(12),
                                  color: const Color(0xFF838383),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: selectedGovernorate,
                              items: EgyptData.egyptData.keys
                                  .map(
                                    (String key) => DropdownMenuItem<String>(
                                      value: key,
                                      child: Text(
                                        key,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: kSize(11),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedGovernorate = val;
                                  selectedCity = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: kHeight(15)),

                  // حقل إدخال العنوان التفصيلي
                  Custom_Text_Field_Booking_Screen(
                    hintText: 'العنوان بالتفصيل',
                    controller: _addressDetailController,
                    width: 220,
                  ),

                  SizedBox(height: kHeight(15)),

                  // زر إرسال الموقع الحالي عبر الـ GPS
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _getCurrentLocation,
                      child: Container(
                        width: kWidth(130),
                        height: kHeight(35),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          border: Border.all(
                            color: const Color(0xFFD1D1D1),
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.circular(kSize(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ارسال الموقع',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: kSize(12),
                                color: const Color(0xFF838383),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: kWidth(5)),
                            Icon(
                              Icons.location_on_rounded,
                              size: kSize(18),
                              color: const Color(0xFFA0A0A0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: kHeight(15)),

            //  قسم تحديد السعر ووحدة التسعير
            Container(
              width: kWidth(354),
              padding: EdgeInsets.all(kSize(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kSize(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: kSize(10),
                    offset: Offset(0, kHeight(4)),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'السعر',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: kHeight(15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // دروب داون لاختيار وحدة التسعير (متر، ساعة، إلخ)
                      Container(
                        width: kWidth(110),
                        height: kHeight(35),
                        padding: EdgeInsets.symmetric(horizontal: kWidth(8)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          border: Border.all(
                            color: const Color(0xFFD1D1D1),
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.circular(kSize(12)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              icon: Icon(
                                Icons.arrow_drop_down_rounded,
                                color: const Color(0xFF424242),
                                size: kSize(24),
                              ),
                              hint: Text(
                                "التسعير",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: kSize(10),
                                  color: const Color(0xFFA0A0A0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: selectedPricingUnit,
                              items:
                                  [
                                        'بالمتر',
                                        'بالقطعة',
                                        'شامل',
                                        'بالساعة',
                                        'باليومية',
                                        'حسب الكمية',
                                      ]
                                      .map(
                                        (val) => DropdownMenuItem(
                                          value: val,
                                          child: Text(
                                            val,
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: kSize(11),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) =>
                                  setState(() => selectedPricingUnit = val),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: kWidth(10)),
                      // حقل إدخال القيمة المالية
                      Custom_Text_Field_Booking_Screen(
                        hintText: 'اضف السعر المناسب للخدمة',
                        controller: _priceController,
                        width: 190,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: kSize(15)),

            //  قسم اختيار موعد بدء العمل (DatePicker)
            Container(
              width: kWidth(354),
              padding: EdgeInsets.all(kSize(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kSize(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: kSize(10),
                    offset: Offset(0, kHeight(4)),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'موعد بدء العمل',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: kSize(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: kHeight(15)),

                  GestureDetector(
                    onTap: () async {
                      final now = DateTime.now();
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: now,
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate =
                              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                        });
                      }
                    },
                    child: Container(
                      width: kWidth(120),
                      height: kHeight(35),
                      padding: EdgeInsets.symmetric(horizontal: kWidth(8)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        border: Border.all(
                          color: const Color(0xFFD1D1D1),
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(kSize(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            color: const Color(0xFF424242),
                            size: kSize(24),
                          ),
                          Text(
                            selectedDate ?? "التاريخ",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: kSize(11),
                              color: selectedDate == null
                                  ? const Color(0xFFA0A0A0)
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: kSize(15)),

            //  زر التأكيد النهائي (طلب خدمة)
            GestureDetector(
              onTap: () {
                print("تم الضغط على متابعة");
              },
              child: Container(
                height: kHeight(60),
                width: kWidth(300),
                margin: const EdgeInsets.only(bottom: 28),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  color: const Color(0xFFF2991D),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                child: const Center(
                  child: Text(
                    'طلب خدمة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
