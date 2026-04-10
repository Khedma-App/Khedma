import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/core/errors/app_exception.dart';
import 'package:khedma/models/service_provider_model.dart';
import 'package:khedma/models/user_model.dart';

/// Handles all Firestore read/write operations for the `users` collection.
///
/// - Never touches Firebase Auth — that is [AuthService]'s responsibility.
/// - Throws [AppException] on failure so the Cubit can emit a clean error state.
class UserService {
  final FirebaseFirestore _firestore;

  UserService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ─── Collection reference ─────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  // ─── Create ───────────────────────────────────────────────────────────────

  /// Writes a new user document to Firestore immediately after sign-up.
  ///
  /// Uses [UserModel.toMap] so the Firestore schema stays in sync with the model.
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

  // ─── Read ─────────────────────────────────────────────────────────────────

  /// Fetches the user document for [uid] and returns a [UserModel].
  ///
  /// Throws [AppException.userDocNotFound] if the document does not exist.
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

  // ─── Update ───────────────────────────────────────────────────────────────

  /// Partially updates a user document with the given [fields].
  ///
  /// Use this for targeted field updates (e.g. `{'isFirstTime': false}`).
  Future<void> updateUserFields(String uid, Map<String, dynamic> fields) async {
    try {
      await _users.doc(uid).update(fields);
    } on FirebaseException catch (e) {
      throw AppException(
        'فشل تحديث بيانات المستخدم',
        code: e.code,
      );
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  /// Marks a provider's `isFirstTime` flag as false after they complete
  /// their profile setup screen.
  Future<void> markFirstTimeComplete(String uid) async {
    await updateUserFields(uid, {'isFirstTime': false});
  }

  /// Marks the user's profile as completed.
  Future<void> markProfileCompleted(String uid) async {
    await updateUserFields(uid, {'profileCompleted': true});
  }

  /// Saves a provider's completed [ServiceProviderModel] profile data
  /// into the `providerData` sub-map and marks their profile as completed.
  ///
  /// Also increments the profession counter in `professions_stats`.
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
