class ServiceModel {
  final String title;
  final String imagePath;
  final String count;

  ServiceModel({
    required this.title,
    required this.imagePath,
    required this.count,
  });
ServiceModel copyWith({
  String? title,
  String? imagePath,
  String? count,
}) {
  return ServiceModel(
    title: title ?? this.title,
    imagePath: imagePath ?? this.imagePath,
    count: count ?? this.count,
  );
}
  factory ServiceModel.fromFirestore(Map<String, dynamic> data, String title, String imagePath) {
    return ServiceModel(
      title: title,
      imagePath: imagePath,
      count: (data['count'] ?? 0).toString(),
    );
  }
}