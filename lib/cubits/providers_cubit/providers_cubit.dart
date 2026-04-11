import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/cubits/providers_cubit/providers_states.dart';
import 'package:khedma/services/provider_service.dart';

/// Manages the provider list stream and the current user's role.
///
/// ─── Usage ────────────────────────────────────────────────────────────────────
/// ```dart
/// // Read role synchronously (no async, no Firestore call):
/// final isClient = context.read<ProvidersCubit>().isClient;
///
/// // React to provider list changes:
/// BlocBuilder<ProvidersCubit, ProvidersStates>(
///   builder: (context, state) {
///     if (state is ProvidersLoadedState) { ... }
///   },
/// )
/// ```
class ProvidersCubit extends Cubit<ProvidersStates> {
  final ProviderService _providerService;
  StreamSubscription? _providersSub;

  /// Whether the current user is a Client (`true`) or Provider (`false`).
  /// Available synchronously after [init] completes.
  bool isClient = true;

  bool _initialized = false;

  ProvidersCubit({required ProviderService providerService})
      : _providerService = providerService,
        super(ProvidersInitialState());

  // ─── Convenience accessor ─────────────────────────────────────────────────

  static ProvidersCubit get(context) => BlocProvider.of(context);

  // ─── Initialization ───────────────────────────────────────────────────────

  /// Call once to load the user's role and subscribe to the providers stream.
  /// Subsequent calls are no-ops (idempotent).
  ///
  /// Forces a token refresh before any Firestore call to prevent the
  /// cold-start race condition where `currentUser` exists but the
  /// ID token hasn't been resolved yet (causes permission-denied).
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    emit(ProvidersLoadingState());

    // ── Guard: wait for a valid auth token before touching Firestore ──
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(ProvidersErrorState('لم يتم تسجيل الدخول'));
      _initialized = false; // allow retry after login
      return;
    }

    try {
      // Force-refresh the ID token so Firestore rules see a valid request.auth.
      await user.getIdToken(true);
    } catch (e) {
      debugPrint('⚠️ Token refresh failed: $e');
      // Continue anyway — the token might still be valid from cache.
    }

    await _fetchUserRole();
    _subscribeToProviders();
  }

  // ─── Internals ────────────────────────────────────────────────────────────

  Future<void> _fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final role = await _providerService.getUserRole(uid);
    isClient = role != 'provider';
  }

  void _subscribeToProviders() {
    _providersSub = _providerService.watchProviders().listen(
      (providers) {
        if (!isClosed) emit(ProvidersLoadedState(providers));
      },
      onError: (e) {
        debugPrint('⛔ ProvidersCubit stream error: $e');
        if (!isClosed) emit(ProvidersErrorState('فشل تحميل مقدمي الخدمات\n$e'));
      },
    );
  }

  // ─── Cleanup ──────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _providersSub?.cancel();
    return super.close();
  }
}
