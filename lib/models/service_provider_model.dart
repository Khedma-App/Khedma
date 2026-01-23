class ServiceProviderModel {
  final String fullName;
  final String profession;
  final String governorate;
  final String profileImageUrl;
  final String pricingType;
  final bool isAvailable;
  bool isFavorite;

  ServiceProviderModel({
    required this.fullName,
    required this.profession,
    required this.governorate,
    required this.profileImageUrl,
    required this.pricingType,
    this.isAvailable = true,
    this.isFavorite = false,
  });
}
