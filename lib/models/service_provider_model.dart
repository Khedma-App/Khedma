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
    this.emergencyworks = false,
  });
}
