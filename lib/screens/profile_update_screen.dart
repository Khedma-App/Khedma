import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/components/custom_action_buttons.dart';
import 'package:khedma/components/custom_profile_text_field.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/user_model.dart';
import 'package:khedma/services/user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  final UserService _userService = UserService();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  String _profileImageUrl = '';
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (!mounted || doc.data() == null) return;

      final data = doc.data()!;
      final user = UserModel.fromMap(data, uid: uid);
      final providerData = data['providerData'] as Map<String, dynamic>?;
      final imgUrl = providerData?['profileImageUrl'] as String? ?? '';

      setState(() {
        _nameController.text = user.fullName;
        _phoneController.text = user.phone;
        _emailController.text = user.email;
        _profileImageUrl = imgUrl;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint('⛔ ProfileUpdateScreen: $e');
    }
  }

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
                if (image != null) {
                  setState(() => _imageFile = File(image.path));
                }
                if (mounted) Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('الكاميرا (Camera)'),
              onTap: () async {
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  setState(() => _imageFile = File(image.path));
                }
                if (mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isSaving = true);

    try {
      // Split the full name back to first and last
      final nameParts = _nameController.text.trim().split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';

      final updates = <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'phone': _phoneController.text.trim(),
      };

      // Update password if provided
      if (_passController.text.isNotEmpty) {
        await FirebaseAuth.instance.currentUser!
            .updatePassword(_passController.text.trim());
      }

      await _userService.updateUserFields(uid, updates);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ التعديلات بنجاح', textAlign: TextAlign.right),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل الحفظ: $e', textAlign: TextAlign.right),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Color(0xFFE19113))),
      );
    }

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
                            _phoneController.text.isNotEmpty
                                ? _phoneController.text
                                : _emailController.text,
                            style: TextStyle(
                              fontSize: kSize(13),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            _nameController.text,
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
                                  : _profileImageUrl.isNotEmpty
                                      ? CachedNetworkImageProvider(_profileImageUrl)
                                          as ImageProvider
                                      : null,
                              child: (_imageFile == null && _profileImageUrl.isEmpty)
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

              CustomProfileTextField(
                label: "رقم الهاتف المحمول",
                controller: _phoneController,
                validator: (v) =>
                    v!.isNotEmpty && v.length < 11 ? "رقم الموبايل مش كامل" : null,
              ),

              SizedBox(height: kHeight(10)),

              Padding(
                padding: EdgeInsets.only(left: kSize(200)),
                child: Text(
                  'تغيير كلمة السر',
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
                label: "كلمة السر الجديدة",
                isPassword: true,
                controller: _passController,
                validator: (v) => v!.isNotEmpty && v.length < 6
                    ? "كلمة السر لازم تكون 6 أرقام أو أكتر"
                    : null,
              ),

              CustomProfileTextField(
                label: "تأكيد كلمة السر",
                isPassword: true,
                controller: _confirmPassController,
                validator: (v) =>
                    v != _passController.text ? "كلمة السر غير متطابقة" : null,
              ),

              SizedBox(height: kHeight(70)),

              CustomBottomActionBar(
                onSave: _isSaving ? () {} : _saveProfile,
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
