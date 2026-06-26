import 'package:firebase_auth/firebase_auth.dart';
import 'package:khedma/core/errors/app_exception.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─── Sign In ──────────────────────────────────────────────────────────────
  Future<User> signIn({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user!;

      if (!user.emailVerified && !email.trim().endsWith('@khedma.local')) {
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

  Future<User> signUp({required String email, required String password}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user!;
      if (!email.trim().endsWith('@khedma.local')) {
        await user.sendEmailVerification();
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw AppException.fromAuthCode(e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  // ─── Phone Auth ───────────────────────────────────────────────────────────

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(AppException) verificationFailed,
  }) async {
    try {
      String formattedPhone = phoneNumber.trim();
      if (formattedPhone.startsWith('01')) {
        formattedPhone = '+20${formattedPhone.substring(1)}';
      } else if (formattedPhone.startsWith('1')) {
        formattedPhone = '+20$formattedPhone';
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) {
          // We can leave this empty or handle auto-resolution.
          // For simplicity and consistency across platforms, we usually rely on the OTP dialog.
        },
        verificationFailed: (FirebaseAuthException e) {
          verificationFailed(AppException.fromAuthCode(e.code));
        },
        codeSent: (String verificationId, int? resendToken) {
          codeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }

  Future<User> signInWithPhoneOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode.trim(),
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user!;
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

  // ─── Upgrade Phone to Email ──────────────────────────────────────────────────
  Future<User> upgradePhoneToEmail(String email, String password) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: email.trim(),
          password: password.trim(),
        );
        final userCredential = await user.linkWithCredential(credential);
        return userCredential.user!;
      }
      throw AppException.unexpected('No user signed in');
    } on FirebaseAuthException catch (e) {
      throw AppException.fromAuthCode(e.code);
    } catch (e) {
      throw AppException.unexpected(e);
    }
  }
}
