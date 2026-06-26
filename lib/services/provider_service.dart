import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/models/service_provider_model.dart';

/// Handles all Firestore read operations related to service providers.
///
/// Keeps Firebase logic out of the UI and Cubit layers.
/// Throws no exceptions — returns safe defaults on failure.
class ProviderService {
  final FirebaseFirestore _firestore;

  ProviderService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ─── Providers Stream ──────────────────────────────────────────────────────

  /// Returns a real-time stream of all providers whose profile is completed.
  ///
  /// Each emission maps Firestore documents to [ServiceProviderModel] objects.
  Stream<List<ServiceProviderModel>> watchProviders() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'provider')
        .where('profileCompleted', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final providers = <ServiceProviderModel>[];
      for (final doc in snapshot.docs) {
        try {
          final data = doc.data();
          final providerData = data['providerData'];
          if (providerData is Map<String, dynamic>) {
            // Fallback: Check root document if profile image is missing or empty in providerData
            var imgUrl = providerData['profileImageUrl'];
            if (imgUrl == null || imgUrl.toString().trim().isEmpty) {
              imgUrl = data['profileImageUrl'] ?? data['personalImage'] ?? data['image'];
              if (imgUrl != null && imgUrl.toString().trim().isNotEmpty) {
                providerData['profileImageUrl'] = imgUrl.toString().trim();
              }
            }

            providers.add(ServiceProviderModel.fromMap(
              providerData,
              documentId: doc.id,
            ));
          }
        } catch (_) {
          // Skip malformed documents — don't crash the whole stream.
        }
      }
      return providers;
    });
  }

  // ─── User Role ─────────────────────────────────────────────────────────────

  /// Reads the user's role from Firestore.
  /// Returns `'Client'` as the safe default if the document doesn't exist.
  Future<String> getUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data()?['role'] as String? ?? 'Client';
    } catch (_) {
      return 'Client';
    }
  }
}
