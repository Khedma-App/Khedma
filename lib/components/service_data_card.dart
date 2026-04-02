import 'dart:io';
import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_data.dart';

class ServiceDataCard extends StatelessWidget {
  final String? selectedService;
  final Function(String?) onServiceChanged;
  final TextEditingController serviceDescriptionController;
  final int? selectedExperience;
  final Function(int?) onExperienceChanged;
  final TextEditingController aboutController;
  final TextEditingController companiesController;
  final List<File> workImages;
  final VoidCallback onAddWorkImage;
  final String? serviceError;
  final String? experienceError;
  final String? workImagesError;

  const ServiceDataCard({
    super.key,
    required this.selectedService,
    required this.onServiceChanged,
    required this.serviceDescriptionController,
    required this.selectedExperience,
    required this.onExperienceChanged,
    required this.aboutController,
    required this.companiesController,
    required this.workImages,
    required this.onAddWorkImage,
    this.serviceError,
    this.experienceError,
    this.workImagesError,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle hintStyle = TextStyle(
      fontFamily: 'Cairo',
      fontSize: kSize(10),
      fontWeight: FontWeight.w700,
      color: const Color(0xFF838383),
      height: 1.0,
    );

    final TextStyle errorStyle = TextStyle(
      fontSize: kSize(11),
      color: Colors.red,
      fontWeight: FontWeight.w500,
    );

    return Container(
      padding: EdgeInsets.all(kSize(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kSize(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: kSize(20),
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اسم الخدمة',
                    style: TextStyle(
                      fontSize: kSize(12),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: kHeight(2)),
                  Container(
                    height: kHeight(40),
                    width: kWidth(110),
                    padding: EdgeInsets.symmetric(horizontal: kWidth(12)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: serviceError != null
                            ? Colors.red
                            : const Color(0xFFADADAD),
                        width: kWidth(0.8),
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: selectedService,
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: Text('اسم الخدمة', style: hintStyle),
                      items: EgyptData.services
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: onServiceChanged,
                    ),
                  ),
                ],
              ),
              SizedBox(width: kWidth(20)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "وصف الخدمة( اختياري )",
                    style: TextStyle(
                      fontSize: kSize(12),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: kHeight(1)),
                  Container(
                    height: kHeight(40),
                    width: kWidth(160),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFADADAD),
                        width: kWidth(0.8),
                      ),
                    ),
                    child: TextField(
                      controller: serviceDescriptionController,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'مثال ( تشطيب شقق / دهان )',
                        hintStyle: hintStyle,
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (serviceError != null)
            Padding(
              padding: EdgeInsets.only(top: kHeight(8)),
              child: Text(serviceError!, style: errorStyle),
            ),
          SizedBox(height: kHeight(10)),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "عدد سنين الخبرة",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    height: kHeight(40),
                    width: kWidth(110),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: experienceError != null
                            ? Colors.red
                            : const Color(0xFFADADAD),
                        width: 0.8,
                      ),
                    ),
                    child: DropdownButton<int>(
                      value: selectedExperience,
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: Text("سنين الخبرة", style: hintStyle),
                      items: List.generate(
                        10,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text("${i + 1} سنوات"),
                        ),
                      ),
                      onChanged: onExperienceChanged,
                    ),
                  ),
                ],
              ),
              SizedBox(width: kWidth(20)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "نبذة عني ( اختياري )",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: kHeight(3)),
                    Container(
                      alignment: Alignment.center,
                      height: kHeight(40),
                      width: kWidth(160),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFADADAD),
                          width: kWidth(0.8),
                        ),
                      ),
                      child: TextField(
                        controller: aboutController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'مثال ( اعمل في الدهانات بأنواعها)',
                          hintStyle: hintStyle,
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (experienceError != null)
            Padding(
              padding: EdgeInsets.only(top: kHeight(8)),
              child: Text(experienceError!, style: errorStyle),
            ),
          SizedBox(height: kHeight(10)),
          const Text(
            "الشركات ( اختياري )",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: kHeight(8)),
          Container(
            width: kWidth(210),
            height: kHeight(30),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(kSize(12)),
              border: Border.all(color: const Color(0xFFADADAD)),
            ),
            child: TextField(
              controller: companiesController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'اكتب الشركات السابق لك العمل بها ان وجد',
                hintStyle: hintStyle,
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          SizedBox(height: kHeight(10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  children: [
                    ...workImages.map(
                      (file) => Container(
                        width: kWidth(70),
                        height: kHeight(70),
                        margin: EdgeInsets.only(right: kSize(10)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kSize(15)),
                          image: DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    if (workImages.length < 5)
                      GestureDetector(
                        onTap: onAddWorkImage,
                        child: Container(
                          margin: EdgeInsets.only(right: kSize(10)),
                          width: kWidth(70),
                          height: kHeight(70),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(kSize(15)),
                            border: workImagesError != null
                                ? Border.all(color: Colors.red, width: 2)
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add,
                                color: Color(0xFF8E8E8E),
                                size: 30,
                              ),
                              Text(
                                "اضافة\nصور الشغل",
                                textAlign: TextAlign.center,
                                style: hintStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (workImagesError != null)
                Padding(
                  padding: EdgeInsets.only(top: kHeight(8)),
                  child: Text(workImagesError!, style: errorStyle),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
