part of 'auth_cubit.dart';

/// ─── Base ────────────────────────────────────────────────────────────────────

abstract class AuthStates {
  const AuthStates();
}

abstract class AuthTabState extends AuthStates {}

/// The login form tab is active.
class AuthLoginTabState extends AuthTabState {}

/// The register options tab is active.
class AuthRegisterTabState extends AuthTabState {}

class AuthLoadingState extends AuthStates {}
class AuthLoginSuccessState extends AuthStates {
  final UserModel user;
  const AuthLoginSuccessState(this.user);
}
class AuthSignUpSuccessState extends AuthStates {}

class AuthPasswordResetSentState extends AuthStates {}

/// An operation failed. Carries the Arabic [message] from [AppException].
/// The UI should display this message in a SnackBar or dialog.
class AuthErrorState extends AuthStates {
  final String message;
  const AuthErrorState(this.message);
}