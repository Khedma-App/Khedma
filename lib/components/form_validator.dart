import 'dart:io';

class FormValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء إدخال الاسم';
    }
    return null;
  }

  static String? validateProfileImage(File? image) {
    if (image == null) {
      return 'الرجاء إضافة صورة شخصية';
    }
    return null;
  }

  static String? validateService(String? service) {
    if (service == null) {
      return 'الرجاء اختيار اسم الخدمة';
    }
    return null;
  }

  static String? validateExperience(int? experience) {
    if (experience == null) {
      return 'الرجاء اختيار عدد سنين الخبرة';
    }
    return null;
  }

  static String? validateWorkImages(List<File> images) {
    if (images.isEmpty) {
      return 'الرجاء إضافة صورة عمل واحدة على الأقل';
    }
    return null;
  }

  static String? validatePriceOption(String? option) {
    if (option == null) {
      return 'الرجاء اختيار طريقة التسعير';
    }
    return null;
  }

  static String? validateGovernorate(String? governorate) {
    if (governorate == null) {
      return 'الرجاء اختيار المحافظة';
    }
    return null;
  }

  static String? validateCity(String? city) {
    if (city == null) {
      return 'الرجاء اختيار المنطقة';
    }
    return null;
  }
}
