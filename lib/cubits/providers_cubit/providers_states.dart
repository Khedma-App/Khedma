import 'package:khedma/models/service_provider_model.dart';

/// ─── Base ────────────────────────────────────────────────────────────────────

abstract class ProvidersStates {}

/// Initial state before any data is loaded.
class ProvidersInitialState extends ProvidersStates {}

/// Providers are being fetched from Firestore.
class ProvidersLoadingState extends ProvidersStates {}

/// Providers loaded successfully from Firestore.
class ProvidersLoadedState extends ProvidersStates {
  final List<ServiceProviderModel> providers;
  ProvidersLoadedState(this.providers);
}

/// An error occurred while fetching providers.
class ProvidersErrorState extends ProvidersStates {
  final String message;
  ProvidersErrorState(this.message);
}
