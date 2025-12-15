import 'package:flutter/material.dart';
import 'package:khedma/components/customt_login_text_form_field.dart';
import 'package:khedma/core/constants.dart';

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
          CustomLoginTextFormField(
            width: kWidth(300),
            hint: 'البريد الإلكتروني او رقم الهاتف',
            controller: emailController,
            validator: _validateEmail,
          ),
          SizedBox(height: kHeight(18)),

          CustomLoginTextFormField(
            width: kWidth(300),
            hint: 'كلمة المرور',
            obscureText: true,
            controller: passwordController,
            validator: _validatePassword,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
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
          SizedBox(height: kHeight(24)),

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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل البريد الإلكتروني او رقم الهاتف';
    }
    bool isEmail = RegExp(
      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value);
    bool isPhone = RegExp(r'^[0-9]{11}$').hasMatch(value);

    if (!isEmail && !isPhone) {
      return 'الرجاء إدخال بريد إلكتروني أو رقم هاتف صحيح';
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
