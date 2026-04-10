import 'package:firebase_auth/firebase_auth.dart';
import 'package:khedma/core/errors/app_exception.dart';

/// Handles all Firebase Authentication operations.
///
/// - Never touches the UI or Navigator.
/// - Throws [AppException] on failure so the Cubit can emit a clean error state.
/// - Returns typed results on success so the Cubit can act on the data.
class AuthService {
  final FirebaseAuth _auth;

  // Accepts a FirebaseAuth instance to allow easy testing/mocking.
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  // ─── Getters ──────────────────────────────────────────────────────────────

  /// The currently signed-in Firebase user, or null if signed out.
  User? get currentUser => _auth.currentUser;

  /// Stream that emits whenever auth state changes (sign in / sign out).
  /// Used by AuthWrapper to reactively route the user.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─── Sign In ──────────────────────────────────────────────────────────────

  /// Signs the user in with email and password.
  ///
  /// Returns the [User] on success.
  /// Throws [AppException.emailNotVerified] if email is not yet confirmed.
  /// Throws [AppException.fromAuthCode] for any Firebase error.
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user!;

      if (!user.emailVerified) {
        // Re-send the verification email so the user isn't stuck.
        await user.sendEmailVerification();
        await _auth.signOut();
        throw AppException.emailNotVerified();
      }

      return user;
    } on AppException {
      // Re-throw our own exceptions untouched.
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AppException.fromAuthCode(e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Sign Up ──────────────────────────────────────────────────────────────

  /// Creates a new Firebase Auth account and sends a verification email.
  ///
  /// The user remains signed in after this call so the Cubit can immediately
  /// write the Firestore document while the auth token is still valid.
  /// The Cubit is responsible for calling [signOut] after the document is saved.
  ///
  /// Returns the new [User] (still unverified at this point).
  Future<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user!;

      // Send verification email immediately after account creation.
      await user.sendEmailVerification();

      // ⚠️ Do NOT sign out here.
      // The Cubit must write the Firestore document first while the
      // auth token is valid, then call signOut() itself.

      return user;
    } on FirebaseAuthException catch (e) {
      throw AppException.fromAuthCode(e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Sign Out ─────────────────────────────────────────────────────────────

  /// Signs the current user out.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AppException.fromAuthCode(e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Password Reset ───────────────────────────────────────────────────────

  /// Sends a password reset email to [email].
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AppException.fromAuthCode(e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Email Verification ───────────────────────────────────────────────────

  /// Re-sends the email verification link to the currently signed-in user.
  Future<void> resendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      throw AppException.fromAuthCode(e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }
}
