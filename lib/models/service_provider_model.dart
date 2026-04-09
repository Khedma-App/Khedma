class ServiceProviderModel {
  final String? id; // إضافة الـ ID مهم جداً للتعامل مع العمليات المستقبلية
  final String fullName;
  final String profession;
  final String governorate;
  final String profileImageUrl;
  final String pricingType;
  final bool isAvailable;
  final int? yearsOfExperience;
  final String? overviewOfExperience;
  final String? previousCompanies;
  final List<String> imagesOfPreviousWorks;
  final bool isFavorite;
  final bool? emergencyworks;
  final bool? canWorkOutsideGovernorate;

  ServiceProviderModel({
    this.id,
    required this.fullName,
    required this.profession,
    required this.governorate,
    required this.profileImageUrl,
    required this.pricingType,
    this.isAvailable = true,
    this.isFavorite = false,
    this.yearsOfExperience,
    this.overviewOfExperience,
    this.previousCompanies,
    required this.imagesOfPreviousWorks,
    this.emergencyworks = false,
    this.canWorkOutsideGovernorate = false,
  });

  // 1. دالة الإرسال لـ Supabase/Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'profession': profession,
      'governorate': governorate,
      'profileImageUrl': profileImageUrl,
      'pricingType': pricingType,
      'isAvailable': isAvailable,
      'yearsOfExperience': yearsOfExperience,
      'overviewOfExperience': overviewOfExperience,
      'previousCompanies': previousCompanies,
      'imagesOfPreviousWorks': imagesOfPreviousWorks, // تُرسل كقائمة روابط
      'isFavorite': isFavorite,
      'emergencyworks': emergencyworks,
      'canWorkOutsideGovernorate': canWorkOutsideGovernorate,
    };
  }

  // 2. دالة الاستقبال -
  factory ServiceProviderModel.fromMap(
    Map<String, dynamic> map, {
    String? documentId,
  }) {
    return ServiceProviderModel(
      id: documentId, // استقبال الـ ID من قاعدة البيانات
      fullName: map['fullName'] ?? 'غير معروف',
      profession: map['profession'] ?? '',
      governorate: map['governorate'] ?? '',

      // التأكد من وجود رابط أو وضع صورة افتراضية لمنع الكراش
      profileImageUrl: map['profileImageUrl'] ?? 'assets/images/profile.png',

      pricingType: map['pricingType'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      yearsOfExperience: map['yearsOfExperience'] as int?,
      overviewOfExperience: map['overviewOfExperience'],
      previousCompanies: map['previousCompanies'],

      // 🔥 التعديل الأهم: التحويل الآمن للقائمة
      // لضمان عدم حدوث خطأ type 'List<dynamic>' is not a subtype of type 'List<String>'
      imagesOfPreviousWorks: map['imagesOfPreviousWorks'] != null
          ? List<String>.from(map['imagesOfPreviousWorks'])
          : [],

      isFavorite: map['isFavorite'] ?? false,
      emergencyworks: map['emergencyworks'] ?? false,
      canWorkOutsideGovernorate: map['canWorkOutsideGovernorate'] ?? false,
    );
  }
}
