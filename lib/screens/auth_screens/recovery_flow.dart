import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khedma/components/customt_login_text_form_field.dart';
import 'package:khedma/components/custum_backgrond_color.dart';
import 'package:khedma/components/custum_backgrond_image.dart';
import 'package:khedma/core/constants.dart';

class RecoveryFlow extends StatefulWidget {
  const RecoveryFlow({super.key});
  static String id = 'RecoveryFlow';

  @override
  State<RecoveryFlow> createState() => _RecoveryFlowState();
}

class _RecoveryFlowState extends State<RecoveryFlow> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const CustumBackgrondImage(),
          const CustumBackgrondColor(),

          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: kHeight(250)),

                Container(
                  width: kScreenWidth,
                  padding: EdgeInsets.only(
                    top: kHeight(40),
                    bottom:
                        kHeight(40) + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _title(),
                        SizedBox(height: kHeight(30)),

                        CustomLoginTextFormField(
                          hint: 'ادخل البريد الإلكتروني',
                          width: kWidth(329),
                          controller: emailController,
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(height: kHeight(40)),

                        _button(onTap: _sendResetEmail),

                        SizedBox(height: kHeight(20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= LOGIC =================

  Future<void> _sendResetEmail() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال رابط إعادة تعيين كلمة المرور على بريدك'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ';

      if (e.code == 'user-not-found') {
        message = 'لا يوجد حساب بهذا البريد الإلكتروني';
      } else if (e.code == 'invalid-email') {
        message = 'البريد الإلكتروني غير صالح';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ================= UI HELPERS =================

  Widget _title() {
    return const Text(
      'إسترجاع كلمة المرور',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
    );
  }

  Widget _button({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: kHeight(60),
        width: kWidth(300),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'إرسال رابط الاسترجاع',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل البريد الإلكتروني';
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'ادخل بريد إلكتروني صحيح';
    }

    return null;
  }
}
