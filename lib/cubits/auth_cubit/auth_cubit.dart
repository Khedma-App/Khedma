import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/errors/app_exception.dart';
import 'package:khedma/models/user_model.dart';
import 'package:khedma/services/auth_service.dart';
import 'package:khedma/services/user_service.dart';

part 'auth_states.dart';

/// Manages all authentication state for the app.
///
/// Orchestrates [AuthService] (Firebase Auth) and [UserService] (Firestore),
/// converting their results and [AppException] errors into clean states that
/// the UI reacts to — without any Firebase imports in the screen layer.
///
/// ─── Usage in BlocConsumer ────────────────────────────────────────────────
/// ```dart
/// BlocConsumer<AuthCubit, AuthStates>(
///   // Tab UI only rebuilds when the tab itself changes.
///   buildWhen: (prev, curr) => curr is AuthTabState,
///   // Navigation and dialogs react to operation results.
///   listenWhen: (prev, curr) => curr is! AuthTabState,
///   builder: (context, state) { ... },
///   listener: (context, state) {
///     if (state is AuthLoginSuccessState) {
///       // Route based on state.user.role / state.user.isFirstTime
///     } else if (state is AuthErrorState) {
///       // Show SnackBar with state.message
///     }
///   },
/// )
/// ```
class AuthCubit extends Cubit<AuthStates> {
  final AuthService _authService;
  final UserService _userService;

  AuthCubit({
    required AuthService authService,
    required UserService userService,
  })  : _authService = authService,
        _userService = userService,
        super(AuthLoginTabState());

  // ─── Convenience accessor ─────────────────────────────────────────────────

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);

  // ─── Tab Toggle (UI only) ─────────────────────────────────────────────────

  /// Switches the auth screen to the login form tab.
  void switchToLogin() => emit(AuthLoginTabState());

  /// Switches the auth screen to the register options tab.
  void switchToRegister() => emit(AuthRegisterTabState());

  // ─── Login ────────────────────────────────────────────────────────────────

  /// Signs the user in and fetches their Firestore profile.
  ///
  /// Emits [AuthLoadingState] → [AuthLoginSuccessState] on success.
  /// Emits [AuthErrorState] on any failure (wrong password, unverified email, etc.)
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoadingState());
    try {
      // Step 1: Firebase Auth sign-in (verifies email check is inside AuthService).
      final firebaseUser = await _authService.signIn(
        email: email,
        password: password,
      );

      // Step 2: Fetch the full Firestore profile to get role + isFirstTime.
      final userModel = await _userService.getUserById(firebaseUser.uid);

      if (isClosed) return;
      emit(AuthLoginSuccessState(userModel));
    } on AppException catch (e) {
      if (isClosed) return;
      emit(AuthErrorState(e.message));
    }
  }

  // ─── Register Provider ────────────────────────────────────────────────────

  /// Creates a Firebase Auth account for a service provider, then writes the
  /// Firestore document in a single orchestrated flow.
  ///
  /// Emits [AuthLoadingState] → [AuthSignUpSuccessState] on success.
  /// Emits [AuthErrorState] on failure.
  Future<void> registerProvider({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required int age,
    required String gender,
  }) async {
    emit(AuthLoadingState());
    try {
      // Step 1: Create the Firebase Auth account + send verification email.
      final firebaseUser = await _authService.signUp(
        email: email,
        password: password,
      );

      // Step 2: Build the typed UserModel to write to Firestore.
      final userModel = UserModel(
        uid: firebaseUser.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        role: 'provider',
        isFirstTime: true,
        profileCompleted: false,
        providerData: ProviderData(
          age: age,
          gender: gender,
        ),
      );

      // Step 3: Write the document to Firestore (user still authenticated here).
      await _userService.createUserDocument(userModel);

      // Step 4: Sign out AFTER the write — verification required before next login.
      await _authService.signOut();

      if (isClosed) return;
      emit(AuthSignUpSuccessState());
    } on AppException catch (e) {
      if (isClosed) return;
      emit(AuthErrorState(e.message));
    }
  }

  // ─── Register Requester ───────────────────────────────────────────────────

  /// Creates a Firebase Auth account for a service requester, then writes the
  /// Firestore document.
  ///
  /// Emits [AuthLoadingState] → [AuthSignUpSuccessState] on success.
  /// Emits [AuthErrorState] on failure.
  Future<void> registerRequester({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
  }) async {
    emit(AuthLoadingState());
    try {
      // Step 1: Create the Firebase Auth account.
      final firebaseUser = await _authService.signUp(
        email: email,
        password: password,
      );

      // Step 2: Build the UserModel (Client role, no age field).
      final userModel = UserModel(
        uid: firebaseUser.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        role: 'Client',
        isFirstTime: false, // Requesters go straight to the main app.
        profileCompleted: false,
        providerData: ProviderData(gender: gender),
      );

      // Step 3: Write the document to Firestore (user still authenticated here).
      await _userService.createUserDocument(userModel);

      // Step 4: Sign out AFTER the write — verification required before next login.
      await _authService.signOut();

      if (isClosed) return;
      emit(AuthSignUpSuccessState());
    } on AppException catch (e) {
      if (isClosed) return;
      emit(AuthErrorState(e.message));
    }
  }

  // ─── Password Reset ───────────────────────────────────────────────────────

  /// Sends a password reset email to [email].
  ///
  /// Emits [AuthLoadingState] → [AuthPasswordResetSentState] on success.
  /// Emits [AuthErrorState] on failure.
  Future<void> sendPasswordReset({required String email}) async {
    emit(AuthLoadingState());
    try {
      await _authService.sendPasswordResetEmail(email: email);
      emit(AuthPasswordResetSentState());
    } on AppException catch (e) {
      emit(AuthErrorState(e.message));
    }
  }

  // ─── Sign Out ─────────────────────────────────────────────────────────────

  /// Signs the user out. AuthWrapper's StreamBuilder will reactively
  /// navigate back to AuthScreen automatically — no explicit navigation needed.
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      // No state emit needed: FirebaseAuth.authStateChanges() in AuthWrapper
      // will emit null and trigger re-routing automatically.
    } on AppException catch (e) {
      emit(AuthErrorState(e.message));
    }
  }
}