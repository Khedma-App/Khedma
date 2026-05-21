import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/cubits/providers_cubit/providers_states.dart';
import 'package:khedma/services/provider_service.dart';

class ProvidersCubit extends Cubit<ProvidersStates> {
  final ProviderService _providerService;
  StreamSubscription? _providersSub;
 bool isClient = true;

  bool _initialized = false;

  ProvidersCubit({required ProviderService providerService})
      : _providerService = providerService,
        super(ProvidersInitialState());

  // ─── Convenience accessor ─────────────────────────────────────────────────

  static ProvidersCubit get(context) => BlocProvider.of(context);

  // ─── Retry (manual) ───────────────────────────────────────────────────────

  /// Resets the cubit and retries initialization from scratch.
  /// Call this from a retry button in the UI.
  void retry() {
    _providersSub?.cancel();
    _providersSub = null;
    _initialized = false;
    init();
  }

  // ─── Initialization ───────────────────────────────────────────────────────
Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    emit(ProvidersLoadingState());
    debugPrint('🔄 ProvidersCubit: init() started');

    // ── Guard: check for authenticated user ──
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('❌ ProvidersCubit: No currentUser — aborting');
      emit(ProvidersErrorState('لم يتم تسجيل الدخول'));
      _initialized = false;
      return;
    }
    debugPrint('✅ ProvidersCubit: User found: ${user.uid}');

    // ── Start stream IMMEDIATELY (non-blocking) ──
    // The cached token from FirebaseAuth is almost always valid.
    // Don't wait for a network round-trip before showing data.
    debugPrint('🔄 ProvidersCubit: Subscribing to providers stream...');
    _subscribeToProviders();

    // ── Background: refresh token + fetch role (fire-and-forget) ──
    _backgroundInit(user);
  }

  Future<void> _backgroundInit(User user) async {
    // Token refresh (best-effort)
    try {
      debugPrint('🔄 ProvidersCubit: [BG] Refreshing ID token...');
      await user.getIdToken(true).timeout(const Duration(seconds: 10));
      debugPrint('✅ ProvidersCubit: [BG] Token refreshed');
    } on TimeoutException {
      debugPrint('⚠️ ProvidersCubit: [BG] Token refresh timed out');
    } catch (e) {
      debugPrint('⚠️ ProvidersCubit: [BG] Token refresh failed: $e');
    }

    // Role fetch (best-effort)
    try {
      debugPrint('🔄 ProvidersCubit: [BG] Fetching user role...');
      await _fetchUserRole().timeout(const Duration(seconds: 10));
      debugPrint('✅ ProvidersCubit: [BG] Role → isClient=$isClient');
    } on TimeoutException {
      debugPrint('⚠️ ProvidersCubit: [BG] Role fetch timed out → default Client');
      isClient = true;
    } catch (e) {
      debugPrint('⚠️ ProvidersCubit: [BG] Role fetch failed: $e → default Client');
      isClient = true;
    }
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
        debugPrint('✅ ProvidersCubit: Stream emitted ${providers.length} providers');
        if (!isClosed) emit(ProvidersLoadedState(providers));
      },
      onError: (e) {
        debugPrint('⛔ ProvidersCubit: Stream error: $e');
        if (!isClosed) emit(ProvidersErrorState('فشل تحميل مقدمي الخدمات\n$e'));
      },
    );

    // ── Safety net: if the stream doesn't emit within 15 seconds,
    //    emit an empty loaded state so the UI is not stuck. ──
    Future.delayed(const Duration(seconds: 15), () {
      if (!isClosed && state is ProvidersLoadingState) {
        debugPrint('⚠️ ProvidersCubit: 15s safety timeout — emitting empty list');
        emit(ProvidersLoadedState([]));
      }
    });
  }

  // ─── Cleanup ──────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _providersSub?.cancel();
    return super.close();
  }
}
