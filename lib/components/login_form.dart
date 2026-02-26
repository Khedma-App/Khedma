import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khedma/components/customt_login_text_form_field.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/screens/auth_screens/recovery_flow.dart';
import 'package:khedma/screens/auth_screens/service_provider_screen.dart';
import 'package:khedma/screens/main_layout_screen.dart';

class LoginForm extends StatefulWidget {
  LoginForm({super.key, this.isFirstTime = false});
  bool isFirstTime; // to track if it's the first time user logs in
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    widget.isFirstTime =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: kHeight(0.5)),
          CustomLoginTextFormField(
            keyboardType: TextInputType.text,
            width: kWidth(300),
            hint: 'البريد الإلكتروني او رقم الهاتف',
            controller: emailController,
            validator: _validateEmail,
            useEnabledColor: true,
          ),
          SizedBox(height: kHeight(20)),

          CustomLoginTextFormField(
            keyboardType: TextInputType.visiblePassword,

            width: kWidth(300),
            hint: 'كلمة المرور',
            obscureText: true,
            controller: passwordController,
            validator: _validatePassword,
            useEnabledColor: true,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RecoveryFlow.id);
                },
                child: Text(
                  'هل نسيت كلمة المرور؟',
                  style: TextStyle(
                    color: Color(0xFFE19113),
                    fontSize: kSize(14),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: kHeight(29)),

          // Login Button continue...
          GestureDetector(
            onTap: isLoading
                ? null
                : () {
                    FocusScope.of(context).unfocus();

                    if (formKey.currentState!.validate()) {
                      _login();
                      try {
                        print("Validation Success... Proceeding to Login");
                        // TODO: Add Firebase Logic Here
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      print("Validation Failed");
                    }
                  },
            child: Container(
              height: kHeight(60),
              width: kWidth(300),
              margin: const EdgeInsets.only(right: 20, left: 20, bottom: 16),

              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: const Center(
                child: Text(
                  'دخول',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      User? user = userCredential.user;

      if (user == null) {
        _showMessage('حدث خطأ غير متوقع');
        return;
      }

      // 1️⃣ التحقق من توثيق البريد الإلكتروني
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        await FirebaseAuth.instance.signOut();
        _showMessage('يرجى تأكيد بريدك الإلكتروني أولاً، تم إرسال رسالة تأكيد');
        return;
      }

      // 2️⃣ جلب بيانات المستخدم من Firestore لفحص الـ Role والـ isFirstTime
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        _showMessage('بيانات المستخدم غير موجودة في قاعدة البيانات');
        return;
      }

      // ... بعد جلب الـ userDoc بنجاح ...
      Map<String, dynamic> userData = userDoc.data()!;
      String role = userData['role'] ?? 'user';
      bool isFirstTime = userData['isFirstTime'] ?? false;

      if (!mounted) return;

      if (role == 'provider' && isFirstTime == true) {
        // 1️⃣ تحديث القيمة في Firestore فوراً لتصبح false
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'isFirstTime': false});

        // 2️⃣ التوجه لصفحة الـ Provider
        Navigator.pushReplacementNamed(context, ServiceProviderScreen.id);
      } else {
        Navigator.pushReplacementNamed(context, MainLayoutScreen.id);
      }
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ';
      if (e.code == 'user-not-found') {
        message = 'الحساب غير موجود';
      } else if (e.code == 'wrong-password') {
        message = 'كلمة المرور غير صحيحة';
      } else if (e.code == 'invalid-email') {
        message = 'البريد الإلكتروني غير صالح';
      }
      _showMessage(message);
    } catch (e) {
      _showMessage('حدث خطأ أثناء جلب البيانات: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // ================= HELPERS =================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.orange),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل البريد الإلكتروني';
    }

    bool isEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
    if (!isEmail) {
      return 'ادخل بريد إلكتروني صحيح';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل رقم الهاتف';
    }

    bool isPhone = RegExp(r'^[0-9]{11}$').hasMatch(value);

    if (!isPhone) {
      return 'الرجاء إدخال رقم هاتف صحيح';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل كلمة المرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور قصيرة جداً';
    }
    return null;
  }
}
