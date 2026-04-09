import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/models/service_provider_model.dart';
import 'package:khedma/screens/main_layout_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class ServiceProviderScreen extends StatefulWidget {
  const ServiceProviderScreen({super.key});
  static String id = 'ServiceProviderScreen';

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String fullName =
      'جاري التحميل...'; // سيظهر هذا النص لجزء من الثانية حتى تأتي البيانات

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data()!;

          // تحديث الواجهة بالاسم الحقيقي
          setState(() {
            fullName = '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'
                .trim();
            if (fullName.isEmpty) fullName = 'مقدم خدمة'; // قيمة احتياطية
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _saveProviderData() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedProfession == null || selectedGovernorate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار المهنة والمحافظة')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      User user = FirebaseAuth.instance.currentUser!;
      final supabase = Supabase.instance.client;

      // المتغير الافتراضي للصورة (لو لم يختر صورة جديدة)
      String profileUrl = worker.profileImageUrl;

      // --- 1. رفع الصورة الشخصية (Profile Image) ---
      if (selectedImage != null) {
        String fileName =
            'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        String path = '${user.uid}/$fileName';

        await supabase.storage
            .from('Provider_images')
            .upload(path, selectedImage!);

        // الحصول على الرابط العام
        profileUrl = supabase.storage
            .from('Provider_images')
            .getPublicUrl(path);
      }

      // --- 2. رفع صور الأعمال السابقة (نفس الكود السابق الخاص بك) ---
      List<String> uploadedUrls = [];
      if (previousWorksImages.isNotEmpty) {
        for (int i = 0; i < previousWorksImages.length; i++) {
          File imageFile = previousWorksImages[i];
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

      // --- 3. بناء الكائن مع رابط الصورة الشخصية الجديد ---
      ServiceProviderModel providerData = ServiceProviderModel(
        fullName: fullName,
        profession: selectedProfession!,
        governorate: selectedGovernorate!,
        profileImageUrl: profileUrl, // الرابط الجديد من Supabase
        pricingType: selectedPriceType,
        isAvailable: selectedStatus == 'متاح',
        yearsOfExperience: int.tryParse(yearsController.text),
        overviewOfExperience: bioController.text.trim(),
        previousCompanies: companiesController.text.trim(),
        imagesOfPreviousWorks: uploadedUrls,
      );

      // --- 4. التحديث في Firestore ---
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
            'providerData': providerData.toMap(),
            'isFirstTime': false,
            'profileCompleted': true,
          });

      // --- 5. زيادة عداد المهنة ---
      await FirebaseFirestore.instance
          .collection('professions_stats')
          .doc(selectedProfession!)
          .set({'count': FieldValue.increment(1)}, SetOptions(merge: true));

      if (mounted) {
        Navigator.pushReplacementNamed(context, MainLayoutScreen.id);
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء الحفظ: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // late TextEditingController firstNameController;
  // late TextEditingController lastNameController;
  late TextEditingController bioController;
  late TextEditingController companiesController;
  late TextEditingController yearsController;

  String? selectedProfession;
  String? selectedGovernorate;
  String selectedPriceType = 'بالأتفاق';
  String selectedStatus = 'متاح';

  final List<String> professions = ['نقاش', 'سباك', 'كهربائي', 'نجار', 'حداد'];
  final List<String> governorates = [
    'اسيوط',
    'سوهاج',
    'قنا',
    'اسوان',
    'المنيا',
  ];

  final ServiceProviderModel worker = ServiceProviderModel(
    fullName: 'محمد أحمد',
    profileImageUrl: 'assets/images/naqash.jpg',
    governorate: 'بور سعيد',
    profession: 'نقاش',
    pricingType: 'بالإتفاق',
    isAvailable: true,
    imagesOfPreviousWorks: [],
  );

  File? selectedImage;
  List<File> previousWorksImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    bioController = TextEditingController();
    companiesController = TextEditingController();
    yearsController = TextEditingController();

    // 🔥 جلب البيانات فور فتح الشاشة
    _fetchUserData();
  }

  @override
  void dispose() {
    // firstNameController.dispose();
    // lastNameController.dispose();
    bioController.dispose();
    companiesController.dispose();
    yearsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: kHeight(43)),
                Text(
                  'مُقدم خِدمة',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: kSize(25),
                  ),
                ),
                SizedBox(height: kHeight(8)),
                Text(
                  'تضاف هنا البيانات التي تظهر للعميل',
                  style: TextStyle(
                    fontSize: kSize(12),
                    color: const Color(0xFF838383),
                  ),
                ),

                SizedBox(height: kHeight(20)),

                Center(
                  child: Container(
                    width: kWidth(329),
                    height: kHeight(160),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(kWidth(10)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null)
                              setState(() => selectedImage = File(image.path));
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: selectedImage != null
                                    ? Image.file(
                                        selectedImage!,
                                        width: kWidth(140),
                                        height: kHeight(140),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        worker.profileImageUrl,
                                        width: kWidth(140),
                                        height: kHeight(140),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: kWidth(140),
                                  height: kHeight(35),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(20),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'تعديل الصورة الشخصية',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: kSize(10),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: kWidth(10)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                fullName,
                                style: TextStyle(
                                  fontSize: kSize(15),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: kHeight(5)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    selectedGovernorate ?? 'المحافظة',
                                    style: TextStyle(
                                      fontSize: kSize(13),
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: kWidth(4)),
                                  Image.asset(
                                    'assets/images/location2.png',
                                    width: kWidth(16),
                                  ),
                                  SizedBox(width: kWidth(10)),
                                  Text(
                                    selectedProfession ?? 'المهنة',
                                    style: TextStyle(
                                      fontSize: kSize(13),
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: kWidth(4)),
                                  Image.asset(
                                    'assets/images/worker.png',
                                    width: kWidth(16),
                                  ),
                                ],
                              ),
                              SizedBox(height: kHeight(5)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    worker.pricingType,
                                    style: TextStyle(
                                      fontSize: kSize(13),
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: kWidth(4)),
                                  Image.asset(
                                    'assets/images/pricing.png',
                                    width: kWidth(16),
                                  ),
                                ],
                              ),
                              SizedBox(height: kHeight(5)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    worker.isAvailable
                                        ? 'متاح للعمل'
                                        : 'غير متاح',
                                    style: TextStyle(
                                      fontSize: kSize(13),
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: kWidth(5)),
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: worker.isAvailable
                                          ? Colors.green
                                          : Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: kWidth(15),
                                  vertical: kHeight(5),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'تواصل',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: kSize(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Form Section ---
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: kWidth(25),
                    vertical: kHeight(20),
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'المهنة',
                            style: TextStyle(
                              fontSize: kSize(12),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFADADAD),
                            ),
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButtonFormField<String>(
                              value: selectedProfession,
                              hint: Text(
                                'اختر المهنة',
                                style: TextStyle(
                                  fontSize: kSize(12),
                                  color: Colors.grey,
                                ),
                              ),
                              isExpanded: true,
                              validator: (val) =>
                                  val == null ? 'يرجى اختيار المهنة' : null,
                              decoration: const InputDecoration(
                                isDense: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                              ),
                              items: professions
                                  .map(
                                    (i) => DropdownMenuItem(
                                      value: i,
                                      child: Text(i),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => selectedProfession = val),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: kHeight(20)),
                      //  Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'المحافظة',
                            style: TextStyle(
                              fontSize: kSize(12),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFADADAD),
                            ),
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButtonFormField<String>(
                              value: selectedGovernorate,
                              hint: Text(
                                'اختر المحافظة',
                                style: TextStyle(
                                  fontSize: kSize(12),
                                  color: Colors.grey,
                                ),
                              ),
                              isExpanded: true,
                              validator: (val) =>
                                  val == null ? 'يرجى اختيار المحافظة' : null,
                              decoration: const InputDecoration(
                                isDense: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                              ),
                              items: governorates
                                  .map(
                                    (i) => DropdownMenuItem(
                                      value: i,
                                      child: Text(i),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => selectedGovernorate = val),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: kHeight(20)),
                      // Experience Bio
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'نبذه عن خبرتك',
                            style: TextStyle(
                              fontSize: kSize(12),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFADADAD),
                            ),
                          ),
                          TextFormField(
                            controller: bioController,
                            textAlign: TextAlign.right,
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'مطلوب' : null,
                            decoration: const InputDecoration(
                              isDense: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFD9D9D9),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: kHeight(20)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'عدد سنين الخبرة',
                            style: TextStyle(
                              fontSize: kSize(12),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFADADAD),
                            ),
                          ),
                          TextFormField(
                            controller: yearsController,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'مطلوب' : null,
                            decoration: const InputDecoration(
                              isDense: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFD9D9D9),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // (Checkboxes) ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kWidth(25)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'السعر',
                        style: TextStyle(
                          fontSize: kSize(12),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFADADAD),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: ['بالأتفاق', 'بالمتر', 'باليوم']
                            .map(
                              (type) => Row(
                                children: [
                                  Text(
                                    type,
                                    style: TextStyle(
                                      fontSize: kSize(13),
                                      color: const Color(0xFF838383),
                                    ),
                                  ),
                                  Checkbox(
                                    value: selectedPriceType == type,
                                    onChanged: (v) => setState(
                                      () => selectedPriceType = type,
                                    ),
                                    activeColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: kHeight(10)),
                      Text(
                        'الحالة',
                        style: TextStyle(
                          fontSize: kSize(12),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFADADAD),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: ['في العمل', 'متاح']
                            .map(
                              (status) => Row(
                                children: [
                                  Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: kSize(13),
                                      color: const Color(0xFF838383),
                                    ),
                                  ),
                                  Checkbox(
                                    value: selectedStatus == status,
                                    onChanged: (v) =>
                                        setState(() => selectedStatus = status),
                                    activeColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),

                // Previous Works Section ---
                Padding(
                  padding: EdgeInsets.all(kWidth(25)),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final List<XFile> images = await _picker
                              .pickMultiImage();
                          if (images.isNotEmpty) {
                            if (previousWorksImages.length + images.length >
                                5) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'عذراً، يمكنك إضافة 5 صور فقط كحد أقصى',
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(
                              () => previousWorksImages.addAll(
                                images.map((img) => File(img.path)),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: kHeight(100),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: kWidth(36),
                                height: kHeight(36),
                                child: Image.asset(
                                  'assets/icons/اضافه الاعمال السابقه.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: kHeight(5)),
                              const Text(
                                'اضافة صور لأعمال سابقة',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (previousWorksImages.isNotEmpty)
                        Container(
                          height: kHeight(80),
                          margin: EdgeInsets.only(top: kHeight(15)),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            itemCount: previousWorksImages.length,
                            itemBuilder: (context, index) => Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  width: kWidth(80),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: FileImage(
                                        previousWorksImages[index],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => previousWorksImages.removeAt(index),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // --- Submit Button ---
                GestureDetector(
                  onTap: isLoading ? null : _saveProviderData,
                  // () {
                  //   if (_formKey.currentState!.validate()) {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(content: Text('جاري حفظ البيانات...')),
                  //     );
                  //     Navigator.pushReplacementNamed(
                  //       context,
                  //       MainLayoutScreen.id,
                  //     );
                  //   }
                  // },
                  child: Container(
                    height: kHeight(60),
                    width: kWidth(300),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'متابعة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: kSize(22),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: kHeight(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.orange),
    );
  }
}
