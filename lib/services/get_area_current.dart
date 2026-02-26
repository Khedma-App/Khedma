import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<String> getCurrentAreaName() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 1. التأكد من أن خدمة الـ GPS تعمل
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return 'خدمة الموقع معطلة';
  }

  // 2. التحقق من الصلاحيات (Permissions)
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return 'تم رفض صلاحية الموقع';
    }
  }

  // 3. الحصول على الإحداثيات (خط الطول والعرض)
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  // 4. تحويل الإحداثيات إلى اسم منطقة (Geocoding)
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      
      // يمكنك استخدام locality (المنطقة) أو subAdministrativeArea (المحافظة)
      return '${place.locality}'; // ستعيد مثلاً: "Port Said" أو "بورسعيد"
    }
  } catch (e) {
    print(e);
  }
  
  return 'غير معروف';
}