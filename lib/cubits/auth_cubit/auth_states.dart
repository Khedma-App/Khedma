part of 'auth_cubit.dart';

/// ─── Base ────────────────────────────────────────────────────────────────────

abstract class AuthStates {
  const AuthStates();
}

/// ─── UI Tab States ────────────────────────────────────────────────────────────
/// These two states control ONLY the login/register tab toggle.
/// BlocBuilder uses `buildWhen: (prev, curr) => curr is AuthTabState`
/// so the tab widget NEVER rebuilds for loading/error/success operations.

abstract class AuthTabState extends AuthStates {}

/// The login form tab is active.
class AuthLoginTabState extends AuthTabState {}

/// The register options tab is active.
class AuthRegisterTabState extends AuthTabState {}

/// ─── Operation States ─────────────────────────────────────────────────────────
/// These states are emitted during async operations.
/// BlocConsumer uses `listenWhen` to react to these without rebuilding the tab UI.

/// An async operation is in progress (login, register, password reset).
class AuthLoadingState extends AuthStates {}

/// Login succeeded. Carries the full [UserModel] so the UI can route
/// based on role and isFirstTime without the Cubit knowing about screens.
class AuthLoginSuccessState extends AuthStates {
  final UserModel user;
  const AuthLoginSuccessState(this.user);
}

/// Registration succeeded. The verification email has been sent.
/// The UI should show a dialog instructing the user to verify their email.
class AuthSignUpSuccessState extends AuthStates {}

/// Password reset email was sent successfully.
/// The UI should show a success snackbar and pop the screen.
class AuthPasswordResetSentState extends AuthStates {}

/// An operation failed. Carries the Arabic [message] from [AppException].
/// The UI should display this message in a SnackBar or dialog.
class AuthErrorState extends AuthStates {
  final String message;
  const AuthErrorState(this.message);
}