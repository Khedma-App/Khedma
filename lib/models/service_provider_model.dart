class ServiceProviderModel {
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
    this.emergencyworks = false, this.canWorkOutsideGovernorate = false,
  });
  // 1. دالة الإرسال لـ Firestore
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
      'imagesOfPreviousWorks': imagesOfPreviousWorks,
      'isFavorite': isFavorite,
      'emergencyworks': emergencyworks,
      'canWorkOutsideGovernorate': canWorkOutsideGovernorate,
    };
  }

  // 2. دالة الاستقبال من Firestore
  factory ServiceProviderModel.fromMap(Map<String, dynamic> map) {
    return ServiceProviderModel(
      fullName: map['fullName'] ?? '',
      profession: map['profession'] ?? '',
      governorate: map['governorate'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      pricingType: map['pricingType'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      yearsOfExperience: map['yearsOfExperience'],
      overviewOfExperience: map['overviewOfExperience'],
      previousCompanies: map['previousCompanies'],
      imagesOfPreviousWorks: List<String>.from(map['imagesOfPreviousWorks'] ?? []),
      isFavorite: map['isFavorite'] ?? false,
      emergencyworks: map['emergencyworks'] ?? false,
      canWorkOutsideGovernorate: map['canWorkOutsideGovernorate'] ?? false,
    );
  }
}
