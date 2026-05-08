import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/components/custom_action_buttons.dart';
import 'package:khedma/components/custom_auth_field.dart';
import 'package:khedma/components/custom_profile_text_field.dart';
import 'package:khedma/core/constants.dart';

class ProfileUpdateScreen extends StatefulWidget {
  static String id = 'profileupdatescreen';
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<ProfileUpdateScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('المعرض (Gallery)'),
              onTap: () async {
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null)
                  setState(() => _imageFile = File(image.path));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('الكاميرا (Camera)'),
              onTap: () async {
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null)
                  setState(() => _imageFile = File(image.path));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: kHeight(150),
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        top: kHeight(75),
                        bottom: kHeight(20),
                        left: kSize(25),
                        right: kSize(25),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(kSize(35)),
                          bottomRight: Radius.circular(kSize(35)),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "0123456789",
                            style: TextStyle(
                              fontSize: kSize(13),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            "اسم المستخدم",
                            style: TextStyle(
                              fontSize: kSize(15),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: kHeight(180),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE19113),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(screenWidth * 0.5, 80),
                        bottomRight: Radius.elliptical(screenWidth * 0.5, 80),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          SizedBox(height: kHeight(10)),
                          Image.asset(
                            "assets/images/logo.png",
                            height: kHeight(35),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: kHeight(100),
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: kSize(55),
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : null,
                              child: _imageFile == null
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                            ),
                            Container(
                              width: kSize(110),
                              height: kSize(110),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "تعديل الصورة",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: kHeight(110)),
              Padding(
                padding: EdgeInsets.only(left: kSize(200)),
                child: Text(
                  'المعلومات الأساسية',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                    height: 1.0,
                  ),
                ),
              ),
              SizedBox(height: kHeight(10)),
              CustomProfileTextField(
                label: "الاسم",
                controller: _nameController,
                validator: (v) => v!.isEmpty ? "من فضلك اكتب الاسم" : null,
              ),

              CustomAuthField(
                hintText: " رقم الهاتف المحمول",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onVerifyPressed: () {},
                validator: (v) =>
                    v!.length < 11 ? "رقم الموبايل مش كامل" : null,
              ),

              CustomProfileTextField(
                label: "تغيير كلمة السر",
                isPassword: true,
                controller: _passController,
                validator: (v) => v!.length < 6
                    ? "كلمة السر لازم تكون 6 أرقام أو أكتر"
                    : null,
              ),
              SizedBox(height: kHeight(10)),

              Padding(
                padding: EdgeInsets.only(left: kSize(200)),

                child: Text(
                  'المعلومات الأساسية',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                    height: 1.0,
                  ),
                ),
              ),
              SizedBox(height: kHeight(10)),

              CustomProfileTextField(
                label: "تغيير كلمة السر",
                isPassword: true,
                controller: _confirmPassController,
                validator: (v) =>
                    v != _passController.text ? "كلمة السر غير متطابقة" : null,
              ),

              SizedBox(height: kHeight(70)),

              CustomBottomActionBar(
                onSave: () {
                  if (_formKey.currentState!.validate()) {
                    print("جاري الحفظ...");
                  }
                },
                onCancel: () => Navigator.pop(context),
              ),
              SizedBox(height: kHeight(30)),
            ],
          ),
        ),
      ),
    );
  }
}
