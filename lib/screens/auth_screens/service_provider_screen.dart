import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/components/basic_info_card.dart';
import 'package:khedma/components/form_validator.dart';
import 'package:khedma/components/location_card.dart';
import 'package:khedma/components/price_card.dart';
import 'package:khedma/components/publish_button.dart';
import 'package:khedma/components/service_data_card.dart';
import 'package:khedma/core/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/models/service_provider_model.dart';
import 'package:khedma/screens/main_layout_screen.dart';
import 'package:khedma/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class ServiceProviderScreen extends StatefulWidget {
  const ServiceProviderScreen({super.key});
  static const String id = 'service_provider_screen';

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  // ================== state ==================
  String? selectedGovernorate;
  String? selectedCity;
  bool isAvailableOutside = false;
  String? selectedPriceOption;
  String? selectedFrom;
  String? selectedTo;

  // متغيرات القسم الأول (الصورة الشخصية)
  File? _image;

  // متغيرات قسم بيانات الخدمة
  final ImagePicker _picker = ImagePicker();
  final List<File> _workImages = [];
  String? selectedService;
  int? selectedExperience;

  // متغيرات إضافية للربط مع المودل
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serviceDescriptionController =
      TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _companiesController = TextEditingController();

  // ================== متغيرات رسائل الخطأ ==================
  String? _nameError;
  String? _profileImageError;
  String? _serviceError;
  String? _experienceError;
  String? _workImagesError;
  String? _priceOptionError;
  String? _governorateError;
  String? _cityError;

  // ================== دورة حياة الشاشة ==================
  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userModel = await UserService().getUserById(user.uid);
        setState(() {
          _nameController.text = '${userModel.firstName} ${userModel.lastName}'
              .trim();
        });
      }
    } catch (e) {
      debugPrint('Error fetching user name: $e');
    }
  }

  // فانكشن التقاط الصورة الشخصية
  Future<void> _pickProfileImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('التقاط صورة'),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (picked != null) {
                    setState(() {
                      _image = File(picked.path);
                      _profileImageError = null;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('اختيار من المعرض'),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (picked != null) {
                    setState(() {
                      _image = File(picked.path);
                      _profileImageError = null;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // فانكشن إضافة صور العمل
  Future<void> _pickWorkImage(ImageSource source) async {
    if (_workImages.length >= 5) return;
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() {
        _workImages.add(File(image.path));
        _workImagesError = null;
      });
    }
  }

  bool isLoading = false;

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('التقاط'),
              onTap: () {
                Navigator.pop(context);
                _pickWorkImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('المعرض'),
              onTap: () {
                Navigator.pop(context);
                _pickWorkImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    setState(() {
      _nameError = FormValidator.validateName(_nameController.text);
      _profileImageError = FormValidator.validateProfileImage(_image);
      _serviceError = FormValidator.validateService(selectedService);
      _experienceError = FormValidator.validateExperience(selectedExperience);
      _workImagesError = FormValidator.validateWorkImages(_workImages);
      _priceOptionError = FormValidator.validatePriceOption(
        selectedPriceOption,
      );
      _governorateError = FormValidator.validateGovernorate(
        selectedGovernorate,
      );
      _cityError = FormValidator.validateCity(selectedCity);
    });

    return _nameError == null &&
        _profileImageError == null &&
        _serviceError == null &&
        _experienceError == null &&
        _workImagesError == null &&
        _priceOptionError == null &&
        _governorateError == null &&
        _cityError == null;
  }

  void _scrollToFirstError() {}

  Future<void> _publishService() async {
    // FIX: State lock prevents multiple rapid executions (triple-taps).
    if (isLoading) return;

    if (!_validateForm()) {
      _scrollToFirstError();
      return;
    }

    setState(() => isLoading = true);

    try {
      User user = FirebaseAuth.instance.currentUser!;
      final supabase = Supabase.instance.client;

      String profileUrl = '';

      if (_image != null) {
        String fileName =
            'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        String path = '${user.uid}/$fileName';
        await supabase.storage.from('Provider_images').upload(path, _image!);
        profileUrl = supabase.storage
            .from('Provider_images')
            .getPublicUrl(path);
      }

      List<String> uploadedUrls = [];
      if (_workImages.isNotEmpty) {
        for (int i = 0; i < _workImages.length; i++) {
          File imageFile = _workImages[i];
          String fileName =
              'work_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
          String path = '${user.uid}/$fileName';
          await supabase.storage
              .from('Provider_images')
              .upload(path, imageFile);
          final String publicUrl = supabase.storage
              .from('Provider_images')
              .getPublicUrl(path);
          uploadedUrls.add(publicUrl);
        }
      }

      ServiceProviderModel providerData = ServiceProviderModel(
        fullName: _nameController.text,
        profession: selectedService ?? '',
        governorate: selectedGovernorate ?? '',
        profileImageUrl: profileUrl,
        pricingType: selectedPriceOption ?? 'بالإتفاق',
        isAvailable: true,
        yearsOfExperience: selectedExperience,
        overviewOfExperience: _aboutController.text.trim(),
        previousCompanies: _companiesController.text.trim(),
        imagesOfPreviousWorks: uploadedUrls,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
            'providerData': providerData.toMap(),
            'isFirstTime': false,
            'profileCompleted': true,
          });

      await FirebaseFirestore.instance
          .collection('professions_stats')
          .doc(selectedService!)
          .set({'count': FieldValue.increment(1)}, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم نشر الخدمة بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, MainLayoutScreen.id);
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء الحفظ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serviceDescriptionController.dispose();
    _aboutController.dispose();
    _companiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF6F6F6);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: kSize(20),
              vertical: kSize(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kHeight(20)),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'مُقدم خِدمة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: kSize(25),
                          fontWeight: FontWeight.w700,
                          height: kHeight(1.0),
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: kHeight(10)),
                      Text(
                        'تضاف هنا البيانات التي تظهر للعميل',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: kSize(12),
                          fontWeight: FontWeight.w700,
                          height: kHeight(1.0),
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: kHeight(20)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    'البيانات الأساسية',
                    style: TextStyle(
                      fontSize: kSize(16),
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                BasicInfoCard(
                  profileImage: _image,
                  nameController: _nameController,
                  onPickImage: _pickProfileImage,
                  nameError: _nameError,
                  profileImageError: _profileImageError,
                  onNameChanged: (value) {
                    if (_nameError != null) {
                      setState(() => _nameError = null);
                    }
                  },
                ),
                SizedBox(height: kHeight(11)),
                Text(
                  'بيانات الخدمة',
                  style: TextStyle(
                    fontSize: kSize(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: kHeight(11)),
                ServiceDataCard(
                  selectedService: selectedService,
                  onServiceChanged: (val) {
                    setState(() {
                      selectedService = val;
                      _serviceError = null;
                    });
                  },
                  serviceDescriptionController: _serviceDescriptionController,
                  selectedExperience: selectedExperience,
                  onExperienceChanged: (val) {
                    setState(() {
                      selectedExperience = val;
                      _experienceError = null;
                    });
                  },
                  aboutController: _aboutController,
                  companiesController: _companiesController,
                  workImages: _workImages,
                  onAddWorkImage: _showImagePickerModal,
                  serviceError: _serviceError,
                  experienceError: _experienceError,
                  workImagesError: _workImagesError,
                ),
                SizedBox(height: kHeight(11)),
                Padding(
                  padding: EdgeInsets.only(right: kSize(10), bottom: kSize(10)),
                  child: Text(
                    'السعر',
                    style: TextStyle(
                      fontSize: kSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PriceCard(
                  selectedPriceOption: selectedPriceOption,
                  onPriceOptionChanged: (option) {
                    setState(() {
                      selectedPriceOption = option;
                      _priceOptionError = null;
                    });
                  },
                  priceOptionError: _priceOptionError,
                ),
                SizedBox(height: kHeight(11)),
                Padding(
                  padding: EdgeInsets.only(right: kSize(10), bottom: kSize(10)),
                  child: Text(
                    'التوفر والمكان',
                    style: TextStyle(
                      fontSize: kSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                LocationCard(
                  selectedGovernorate: selectedGovernorate,
                  selectedCity: selectedCity,
                  isAvailableOutside: isAvailableOutside,
                  selectedFrom: selectedFrom,
                  selectedTo: selectedTo,
                  onGovernorateChanged: (val) {
                    setState(() {
                      selectedGovernorate = val;
                      selectedCity = null;
                      _governorateError = null;
                      _cityError = null;
                    });
                  },
                  onCityChanged: (val) {
                    setState(() {
                      selectedCity = val;
                      _cityError = null;
                    });
                  },
                  onAvailableOutsideChanged: (val) {
                    setState(() {
                      isAvailableOutside = val;
                    });
                  },
                  onFromTimeChanged: (val) {
                    setState(() {
                      selectedFrom = val;
                    });
                  },
                  onToTimeChanged: (val) {
                    setState(() {
                      selectedTo = val;
                    });
                  },
                  governorateError: _governorateError,
                  cityError: _cityError,
                ),
                SizedBox(height: kHeight(30)),
                PublishButton(
                  onPressed: _publishService,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
