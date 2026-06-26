import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/core/errors/app_exception.dart';
import 'package:khedma/core/helpers/validation_helper.dart';
import 'package:khedma/models/service_provider_model.dart';
import 'package:khedma/models/user_model.dart';
import 'package:khedma/models/review_model.dart';

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

  // ─── Reviews ──────────────────────────────────────────────────────────────

  Future<ReviewModel?> getReviewByChatRoomId(String providerId, String chatRoomId) async {
    try {
      final snapshot = await _users
          .doc(providerId)
          .collection('reviews')
          .where('chatRoomId', isEqualTo: chatRoomId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return ReviewModel.fromMap(snapshot.docs.first.data(), id: snapshot.docs.first.id);
      }
      return null;
    } catch (e) {
      throw AppException('فشل جلب التقييم', code: 'fetch_review_error');
    }
  }

  Future<List<ReviewModel>> getProviderReviews(String providerId) async {
    try {
      final snapshot = await _users
          .doc(providerId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => ReviewModel.fromMap(doc.data(), id: doc.id)).toList();
    } catch (e) {
      throw AppException('فشل جلب التقييمات', code: 'fetch_reviews_error');
    }
  }

  Future<void> submitReview(ReviewModel review) async {
    try {
      final providerRef = _users.doc(review.providerId);
      final reviewRef = review.id.isEmpty
          ? providerRef.collection('reviews').doc()
          : providerRef.collection('reviews').doc(review.id);

      // 1. Save or update the review
      await reviewRef.set(review.toMap(), SetOptions(merge: true));

      // 2. Fetch all reviews to recalculate the average
      final allReviewsSnapshot = await providerRef.collection('reviews').get();
      
      final allReviewsData = allReviewsSnapshot.docs.map((doc) => doc.data()).toList();
      
      double totalScore = 0.0;
      int ratingCount = 0;

      for (var data in allReviewsData) {
        final negotiation = (data['negotiationRating'] as num?)?.toDouble();
        final service = (data['serviceRating'] as num?)?.toDouble();

        // Calculate an average per review if both exist, otherwise use whichever exists
        if (negotiation != null && service != null) {
          totalScore += (negotiation + service) / 2;
          ratingCount++;
        } else if (negotiation != null) {
          totalScore += negotiation;
          ratingCount++;
        } else if (service != null) {
          totalScore += service;
          ratingCount++;
        }
      }

      final newAverage = ratingCount > 0 ? totalScore / ratingCount : 0.0;

      // 3. Update the provider's overall rating
      await providerRef.set({
        'providerData': {
          'rating': double.parse(newAverage.toStringAsFixed(1)),
        }
      }, SetOptions(merge: true));
    } catch (e, stackTrace) {
      print('submitReview error: $e');
      print(stackTrace);
      throw AppException('فشل حفظ التقييم: $e', code: 'submit_review_error');
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
