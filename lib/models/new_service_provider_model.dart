class NewServiceProviderModel {
  String? name;
  String? profileImage;
  String? serviceName;
  String? serviceDescription;
  int? experience;
  String? about;
  String? companies;
  List<String> workImages;
  String? priceOption;
  String? governorate;
  String? city;
  bool isAvailableOutside;
  String? fromTime;
  String? toTime;

  NewServiceProviderModel({
    this.name,
    this.profileImage,
    this.serviceName,
    this.serviceDescription,
    this.experience,
    this.about,
    this.companies,
    this.workImages = const [],
    this.priceOption,
    this.governorate,
    this.city,
    this.isAvailableOutside = false,
    this.fromTime,
    this.toTime,
  });
}
