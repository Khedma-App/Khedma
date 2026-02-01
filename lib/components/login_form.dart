import 'package:flutter/material.dart';
import 'package:khedma/components/customt_login_text_form_field.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/screens/auth_screens/recovery_flow.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            validator: _validatePhone,
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
            onTap: () {
              FocusScope.of(context).unfocus();

              if (formKey.currentState!.validate()) {
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
