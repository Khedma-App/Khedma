import 'package:flutter/material.dart';
import 'package:khedma/components/customt_login_text_form_field.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/screens/login_screen.dart';
// import 'package:khedma/screens/login_screen.dart';
import 'package:khedma/screens/register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  static String id = 'welcome-screen';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? validateEmail(String? value) {
      if (value == null || value.isEmpty) {
        return 'ادخل البريد الإلكتروني او رقم الهاتف';
      }
      bool isEmail = value.contains('@') && value.contains('.');
      bool isPhone = value.length == 11 && int.tryParse(value) != null;

      if (!isEmail && !isPhone) {
        return 'الرجاء إدخال بريد إلكتروني أو رقم هاتف صحيح';
      }
      return null;
    }

    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'ادخل كلمة المرور';
      }
      return null;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bac.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: kHeight(290)),
              Container(
                height: kHeight(554),
                width: kScreenWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00E19113), Color(0xbbEF9B17)],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: kHeight(275)),
                    Image.asset(
                      'assets/images/logo.png',
                      width: kWidth(150),
                      // height: kHeight(150),
                    ),
                    Text(
                      '! كل الخدمات في جيبك',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: Container(
                        width: kWidth(300),
                        height: kHeight(60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            'ابدأ دلوقتي',
                            style: TextStyle(
                              color: Color(0xFFE19113),
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
