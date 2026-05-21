import 'package:firebase_auth/firebase_auth.dart';
import 'package:khedma/core/errors/app_exception.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

   User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─── Sign In ──────────────────────────────────────────────────────────────
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

      await user.sendEmailVerification();

      return user;
    } on FirebaseAuthException catch (e) {
      throw AppException.fromAuthCode(e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Sign Out ─────────────────────────────────────────────────────────────

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
