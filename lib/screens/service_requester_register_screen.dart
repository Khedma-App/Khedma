import 'dart:io';

import 'package:flutter/material.dart';
import 'package:khedma/components/customt_login_text_form_field.dart';
import 'package:khedma/components/custum_backgrond_color.dart';
import 'package:khedma/components/custum_backgrond_image.dart';
import 'package:khedma/components/image_picker.dart';
import 'package:khedma/core/constants.dart';

class ServiceRequesterRegisterScreen extends StatefulWidget {
  const ServiceRequesterRegisterScreen({super.key});
  static String id = 'ServiceProviderInformation';

  @override
  State<ServiceRequesterRegisterScreen> createState() =>
      _ServiceRequesterRegisterScreenState();
}

class _ServiceRequesterRegisterScreenState
    extends State<ServiceRequesterRegisterScreen> {
  File? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustumBackgrondImage(),
          CustumBackgrondColor(),
          Column(
            children: [
              SizedBox(height: kHeight(195)),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: kScreenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: kHeight(29)),
                              Text(
                                'طالب خِدمة',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: kHeight(39)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomLoginTextFormField(
                                    hint: 'الاســم الاخير',
                                    width: kWidth(160),
                                  ),
                                  SizedBox(width: kWidth(9)),
                                  CustomLoginTextFormField(
                                    hint: 'الاســم الاول',
                                    width: kWidth(160),
                                  ),
                                ],
                              ),
                              SizedBox(height: kHeight(20)),
                              CustomLoginTextFormField(
                                hint: 'رقم الهاتف المحمول',
                                width: kWidth(329),
                              ),
                              SizedBox(height: kHeight(20)),
                              CustomLoginTextFormField(
                                hint: 'كلمة المرور',
                                width: kWidth(329),
                              ),
                              SizedBox(height: kHeight(20)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 31.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: kWidth(155),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.orange,
                                          width: 1,
                                        ),
                                      ),
                                      child: DropdownMenu(
                                        width: kWidth(155),
                                        menuStyle: MenuStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                Colors.white,
                                              ),
                                        ),
                                        inputDecorationTheme:
                                            InputDecorationTheme(
                                              border: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                        leadingIcon: const Icon(
                                          Icons.arrow_drop_down,
                                        ),
                                        showTrailingIcon: false,
                                        hintText: 'النوع',

                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),

                                        dropdownMenuEntries: const [
                                          DropdownMenuEntry(
                                            label: 'ذكر',
                                            value: 'ذكر',
                                          ),
                                          DropdownMenuEntry(
                                            label: 'أنثى',
                                            value: 'أنثى',
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          color: Colors.orange,
                                          width: 1,
                                        ),
                                      ),

                                      child: ImageInput(
                                        image: image,
                                        onImagePicked: (file) =>
                                            setState(() => image = file),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: kHeight(40)),
                              // Continue button
                              GestureDetector(
                                onTap: () {
                                  // Handle login action
                                },
                                child: Container(
                                  height: kHeight(60),
                                  width: kWidth(300),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'متابعة',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: kHeight(60)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
