/// Reusable form validation helpers with Arabic error messages.
class ValidationHelper {
  /// Name: min 2 chars, Arabic/English letters + spaces only.
  static String? validateName(String? value, {String fieldName = 'الاسم'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName مطلوب';
    if (value.trim().length < 2)
      return '$fieldName يجب أن يكون حرفين على الأقل';
    if (!RegExp(r'^[\u0621-\u064Aa-zA-Z\s]+$').hasMatch(value)) {
      return '$fieldName يجب أن يحتوي على حروف فقط';
    }
    return null;
  }

  /// Egyptian phone: 01[0125] followed by 8 digits.
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'رقم الهاتف مطلوب';
    final clean = value.replaceAll(RegExp(r'[\s\-]'), '');
    if (!RegExp(r'^01[0125]\d{8}$').hasMatch(clean)) {
      return 'رقم الهاتف غير صحيح (مثال: 01012345678)';
    }
    return null;
  }

  /// Standard email validation.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'البريد الإلكتروني مطلوب';
    if (!RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w{2,}$').hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  /// Password: min 8 chars, at least 1 letter + 1 digit.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'كلمة المرور مطلوبة';
    if (value.length < 8) return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$').hasMatch(value)) {
      return 'كلمة المرور يجب أن تحتوي على حروف وأرقام';
    }
    return null;
  }

  /// Positive number.
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) return 'السعر مطلوب';
    final price = double.tryParse(value);
    if (price == null || price <= 0) return 'السعر يجب أن يكون رقم موجب';
    return null;
  }

  /// Age: between 18 and 70.
  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) return 'السن مطلوب';
    final age = int.tryParse(value);
    if (age == null || age < 18 || age > 70) {
      return 'الرجاء إدخال سن صحيح بين 18 و 70';
    }
    return null;
  }

  /// Description: min 10 chars.
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) return 'الوصف مطلوب';
    if (value.trim().length < 10) return 'الوصف يجب أن يكون 10 أحرف على الأقل';
    return null;
  }

  /// Generic required field.
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName مطلوب';
    return null;
  }

  /// Confirm Password.
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'تأكيد كلمة المرور مطلوب';
    if (value != password) return 'كلمة السر غير متطابقة';
    return null;
  }
}
