/// Represents a service provider's public profile — the data displayed
/// on cards, info screens, and search results.
///
/// This replaces both the old `ServiceProviderModel` and the now-deleted
/// `NewServiceProviderModel` which was an incomplete, mutable duplicate.
class ServiceProviderModel {
  final String? id;
  final String fullName;
  final String profession;
  final String governorate;
  final String city;
  final String profileImageUrl;
  final String pricingType;
  final bool isAvailable;
  final bool isFavorite;
  final bool emergencyWorks;
  final bool canWorkOutsideGovernorate;
  final int? yearsOfExperience;
  final String? overviewOfExperience;
  final String? previousCompanies;
  final String? serviceDescription;
  final List<String> imagesOfPreviousWorks;

  /// Working hours range, e.g. "08:00" → "20:00"
  final String? fromTime;
  final String? toTime;

  /// Average rating (0.0–5.0). Populated by the reviews backend.
  final double rating;

  /// Number of completed service orders.
  final int completedOrders;

  const ServiceProviderModel({
    this.id,
    required this.fullName,
    required this.profession,
    required this.governorate,
    this.city = '',
    required this.profileImageUrl,
    required this.pricingType,
    this.isAvailable = true,
    this.isFavorite = false,
    this.emergencyWorks = false,
    this.canWorkOutsideGovernorate = false,
    this.yearsOfExperience,
    this.overviewOfExperience,
    this.previousCompanies,
    this.serviceDescription,
    this.imagesOfPreviousWorks = const [],
    this.fromTime,
    this.toTime,
    this.rating = 0.0,
    this.completedOrders = 0,
  });

  // ─── Serialization ────────────────────────────────────────────────────────

  factory ServiceProviderModel.fromMap(
    Map<String, dynamic> map, {
    String? documentId,
  }) {
    return ServiceProviderModel(
      id: documentId,
      fullName: map['fullName'] as String? ?? 'غير معروف',
      profession: map['profession'] as String? ?? '',
      governorate: map['governorate'] as String? ?? '',
      city: map['city'] as String? ?? '',
      profileImageUrl:
          map['profileImageUrl'] as String? ?? 'assets/images/profile.png',
      pricingType: map['pricingType'] as String? ?? '',
      isAvailable: map['isAvailable'] as bool? ?? true,
      isFavorite: map['isFavorite'] as bool? ?? false,
      emergencyWorks: map['emergencyWorks'] as bool? ?? false,
      canWorkOutsideGovernorate:
          map['canWorkOutsideGovernorate'] as bool? ?? false,
      yearsOfExperience: map['yearsOfExperience'] as int?,
      overviewOfExperience: map['overviewOfExperience'] as String?,
      previousCompanies: map['previousCompanies'] as String?,
      serviceDescription: map['serviceDescription'] as String?,
      imagesOfPreviousWorks: map['imagesOfPreviousWorks'] != null
          ? List<String>.from(map['imagesOfPreviousWorks'] as List)
          : const [],
      fromTime: map['fromTime'] as String?,
      toTime: map['toTime'] as String?,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      completedOrders: map['completedOrders'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'profession': profession,
      'governorate': governorate,
      'city': city,
      'profileImageUrl': profileImageUrl,
      'pricingType': pricingType,
      'isAvailable': isAvailable,
      'isFavorite': isFavorite,
      'emergencyWorks': emergencyWorks,
      'canWorkOutsideGovernorate': canWorkOutsideGovernorate,
      'yearsOfExperience': yearsOfExperience,
      'overviewOfExperience': overviewOfExperience,
      'previousCompanies': previousCompanies,
      'serviceDescription': serviceDescription,
      'imagesOfPreviousWorks': imagesOfPreviousWorks,
      'fromTime': fromTime,
      'toTime': toTime,
      'rating': rating,
      'completedOrders': completedOrders,
    };
  }

  // ─── copyWith ─────────────────────────────────────────────────────────────

  ServiceProviderModel copyWith({
    String? id,
    String? fullName,
    String? profession,
    String? governorate,
    String? city,
    String? profileImageUrl,
    String? pricingType,
    bool? isAvailable,
    bool? isFavorite,
    bool? emergencyWorks,
    bool? canWorkOutsideGovernorate,
    int? yearsOfExperience,
    String? overviewOfExperience,
    String? previousCompanies,
    String? serviceDescription,
    List<String>? imagesOfPreviousWorks,
    String? fromTime,
    String? toTime,
    double? rating,
    int? completedOrders,
  }) {
    return ServiceProviderModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      profession: profession ?? this.profession,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      pricingType: pricingType ?? this.pricingType,
      isAvailable: isAvailable ?? this.isAvailable,
      isFavorite: isFavorite ?? this.isFavorite,
      emergencyWorks: emergencyWorks ?? this.emergencyWorks,
      canWorkOutsideGovernorate:
          canWorkOutsideGovernorate ?? this.canWorkOutsideGovernorate,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      overviewOfExperience: overviewOfExperience ?? this.overviewOfExperience,
      previousCompanies: previousCompanies ?? this.previousCompanies,
      serviceDescription: serviceDescription ?? this.serviceDescription,
      imagesOfPreviousWorks:
          imagesOfPreviousWorks ?? this.imagesOfPreviousWorks,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      rating: rating ?? this.rating,
      completedOrders: completedOrders ?? this.completedOrders,
    );
  }
}
