/// Represents the nested provider-specific data stored inside
/// the Firestore `users/{uid}/providerData` sub-map.
class ProviderData {
  final int? age;
  final String? gender;
  final String serviceType;
  final double rating;
  final int completedJobs;
  final bool isAvailable;

  const ProviderData({
    this.age,
    this.gender,
    this.serviceType = '',
    this.rating = 0.0,
    this.completedJobs = 0,
    this.isAvailable = true,
  });

  // ─── Serialization ────────────────────────────────────────────────────────

  factory ProviderData.fromMap(Map<String, dynamic> map) {
    return ProviderData(
      age: map['age'] as int?,
      gender: map['gender'] as String?,
      serviceType: map['serviceType'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      completedJobs: map['completedJobs'] as int? ?? 0,
      isAvailable: map['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'gender': gender,
      'serviceType': serviceType,
      'rating': rating,
      'completedJobs': completedJobs,
      'isAvailable': isAvailable,
    };
  }

  // ─── copyWith ─────────────────────────────────────────────────────────────

  ProviderData copyWith({
    int? age,
    String? gender,
    String? serviceType,
    double? rating,
    int? completedJobs,
    bool? isAvailable,
  }) {
    return ProviderData(
      age: age ?? this.age,
      gender: gender ?? this.gender,
      serviceType: serviceType ?? this.serviceType,
      rating: rating ?? this.rating,
      completedJobs: completedJobs ?? this.completedJobs,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

/// Unified model for all users (both 'provider' and 'Client' roles).
/// Maps directly to the Firestore `users/{uid}` document schema.
class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  /// Either 'provider' or 'Client' — set at registration time.
  final String role;

  final bool profileCompleted;

  /// Only relevant for providers: true on first login, triggers profile setup.
  final bool isFirstTime;

  final ProviderData? providerData;

  const UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone = '',
    required this.role,
    this.profileCompleted = false,
    this.isFirstTime = false,
    this.providerData,
  });

  // ─── Convenience getters ──────────────────────────────────────────────────

  String get fullName => '$firstName $lastName';
  bool get isProvider => role == 'provider';
  bool get isClient => role == 'Client';

  // ─── Serialization ────────────────────────────────────────────────────────

  factory UserModel.fromMap(Map<String, dynamic> map, {required String uid}) {
    return UserModel(
      uid: uid,
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      role: map['role'] as String? ?? 'Client',
      profileCompleted: map['profileCompleted'] as bool? ?? false,
      isFirstTime: map['isFirstTime'] as bool? ?? false,
      providerData: map['providerData'] != null
          ? ProviderData.fromMap(
              map['providerData'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'role': role,
      'profileCompleted': profileCompleted,
      'isFirstTime': isFirstTime,
      if (providerData != null) 'providerData': providerData!.toMap(),
    };
  }

  // ─── copyWith ─────────────────────────────────────────────────────────────

  UserModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? role,
    bool? profileCompleted,
    bool? isFirstTime,
    ProviderData? providerData,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      providerData: providerData ?? this.providerData,
    );
  }
}
