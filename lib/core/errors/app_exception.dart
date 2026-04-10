/// A clean wrapper that converts Firebase/network errors into user-facing
/// Arabic messages.
///
/// Usage in a Service:
/// ```dart
/// } on FirebaseAuthException catch (e) {
///   throw AppException.fromAuthCode(e.code);
/// } catch (e) {
///   throw AppException.unexpected(e);
/// }
/// ```
///
/// Usage in a Cubit:
/// ```dart
/// } on AppException catch (e) {
///   emit(AuthErrorState(e.message));
/// }
/// ```
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  // ─── Named constructors ───────────────────────────────────────────────────

  /// Translates a [FirebaseAuthException] code to an Arabic message.
  factory AppException.fromAuthCode(String code) {
    return AppException(_authCodeToMessage(code), code: code);
  }

  /// Wraps any unexpected exception.
  factory AppException.unexpected(Object e) {
    return AppException('حدث خطأ غير متوقع، يرجى المحاولة مجدداً', code: 'unexpected');
  }

  /// Used when the email is not yet verified.
  factory AppException.emailNotVerified() {
    return const AppException(
      'يرجى تأكيد بريدك الإلكتروني أولاً.\nتم إرسال رسالة التحقق مجدداً.',
      code: 'email-not-verified',
    );
  }

  /// Used when no Firestore document is found for the logged-in user.
  factory AppException.userDocNotFound() {
    return const AppException(
      'بيانات المستخدم غير موجودة، يرجى التواصل مع الدعم.',
      code: 'user-doc-not-found',
    );
  }

  // ─── Private helpers ──────────────────────────────────────────────────────

  static String _authCodeToMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً (6 أحرف على الأقل)';
      case 'user-not-found':
        return 'لا يوجد حساب مرتبط بهذا البريد الإلكتروني';
      case 'wrong-password':
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 'user-disabled':
        return 'هذا الحساب موقوف، تواصل مع الدعم';
      case 'too-many-requests':
        return 'محاولات كثيرة جداً، انتظر قليلاً ثم حاول مجدداً';
      case 'network-request-failed':
        return 'تحقق من اتصالك بالإنترنت';
      case 'operation-not-allowed':
        return 'هذه العملية غير مسموح بها حالياً';
      default:
        return 'حدث خطأ، يرجى المحاولة مجدداً';
    }
  }

  @override
  String toString() => 'AppException[$code]: $message';
}
