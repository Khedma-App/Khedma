import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:khedma/core/errors/app_exception.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instanceFor(bucket: 'gs://khidma-2d423.firebasestorage.app');

  /// Uploads a profile image and returns the download URL
  Future<String> uploadProfileImage(String uid, File imageFile) async {
    try {
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'Provider_images/$uid/$fileName';
      final ref = _storage.ref().child(path);
      
      final bytes = await imageFile.readAsBytes();
      await ref.putData(bytes).timeout(const Duration(seconds: 60));
      return await ref.getDownloadURL();
    } catch (e) {
      throw AppException('فشل رفع الصورة الشخصية: $e');
    }
  }

  /// Uploads a work image and returns the download URL
  Future<String> uploadWorkImage(String uid, File imageFile, int index) async {
    try {
      final fileName = 'work_${DateTime.now().millisecondsSinceEpoch}_$index.jpg';
      final path = 'Provider_images/$uid/$fileName';
      final ref = _storage.ref().child(path);
      
      final bytes = await imageFile.readAsBytes();
      await ref.putData(bytes).timeout(const Duration(seconds: 60));
      return await ref.getDownloadURL();
    } catch (e) {
      throw AppException('فشل رفع صورة سابقة الأعمال: $e');
    }
  }
}
