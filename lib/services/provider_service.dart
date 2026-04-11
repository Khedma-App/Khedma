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
