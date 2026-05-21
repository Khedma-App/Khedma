import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/core/errors/app_exception.dart';
import 'package:khedma/core/helpers/validation_helper.dart';
import 'package:khedma/models/service_provider_model.dart';
import 'package:khedma/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore;

  UserService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ─── Collection reference ─────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

 Future<void> createUserDocument(UserModel user) async {
    try {
      await _users.doc(user.uid).set({
        ...user.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw AppException(
        'فشل حفظ بيانات المستخدم، يرجى المحاولة مجدداً',
        code: e.code,
      );
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

 Future<UserModel> getUserById(String uid) async {
    try {
      final doc = await _users.doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        throw AppException.userDocNotFound();
      }

      return UserModel.fromMap(doc.data()!, uid: uid);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw AppException(
        'فشل جلب بيانات المستخدم',
        code: e.code,
      );
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

 Future<void> updateUserFields(String uid, Map<String, dynamic> fields) async {
    try {
      // Sanitize data before saving
      final sanitizedUpdates = <String, dynamic>{};
      
      fields.forEach((key, value) {
        if (value is String) {
          // Trim whitespace
          sanitizedUpdates[key] = value.trim();
          
          // Additional validation based on field
          if (key == 'email') {
            if (ValidationHelper.validateEmail(value) != null) {
              throw AppException('البريد الإلكتروني غير صحيح');
            }
          } else if (key == 'phone') {
            if (ValidationHelper.validatePhone(value) != null) {
              throw AppException('رقم الهاتف غير صحيح');
            }
          }
        } else {
          sanitizedUpdates[key] = value;
        }
      });
      
      await _users.doc(uid).update(sanitizedUpdates);
    } on AppException {
      rethrow;
    } on FirebaseException catch (e) {
      throw AppException(
        'فشل تحديث بيانات المستخدم',
        code: e.code,
      );
    } catch (e) {
      throw AppException('فشل تحديث البيانات: ${e.toString()}');
    }
  }

  Future<void> markFirstTimeComplete(String uid) async {
    await updateUserFields(uid, {'isFirstTime': false});
  }

  /// Marks the user's profile as completed.
  Future<void> markProfileCompleted(String uid) async {
    await updateUserFields(uid, {'profileCompleted': true});
  }
Future<void> saveProviderProfile({
    required String uid,
    required ServiceProviderModel profile,
  }) async {
    try {
      final batch = _firestore.batch();

      // 1. Update the user document with the provider profile data.
      batch.update(_users.doc(uid), {
        'providerData': profile.toMap(),
        'isFirstTime': false,
        'profileCompleted': true,
      });

      // 2. Increment the profession counter in the stats collection.
      final statsRef = _firestore
          .collection('professions_stats')
          .doc(profile.profession);

      batch.set(
        statsRef,
        {'count': FieldValue.increment(1)},
        SetOptions(merge: true),
      );

      await batch.commit();
    } on FirebaseException catch (e) {
      throw AppException(
        'فشل حفظ بيانات الملف الشخصي',
        code: e.code,
      );
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Stream ───────────────────────────────────────────────────────────────

  /// Returns a real-time stream of the user document.
  ///
  /// Useful for screens that need to reflect live profile updates.
  Stream<UserModel?> watchUser(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromMap(doc.data()!, uid: uid);
    });
  }
}
