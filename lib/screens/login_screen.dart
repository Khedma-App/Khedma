import 'package:flutter/material.dart';
import 'package:khedma/components/customt_login_text_form_field.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bac.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: kHeight(290)),
              Container(
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
                    SizedBox(height: kHeight(130)),
                    Container(
                      width: kScreenWidth,
                      // height: kHeight(447),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: kHeight(29)),
                          //login and register buttons
                          Container(
                            width: kWidth(330),
                            height: kHeight(50),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // login button
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: kHeight(42),
                                    width: kWidth(160),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      color: Colors.orange,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'تسجيل الدخول',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // register button
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RegisterScreen.id,
                                    );
                                  },
                                  child: SizedBox(
                                    width: kScreenWidth * 0.39,
                                    child: Center(
                                      child: Text(
                                        'إنشاء حساب',
                                        style: TextStyle(
                                          color: Color(0xFF838383),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // email and password text fields
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                SizedBox(height: kHeight(60)),
                                // email text field
                                CustomLoginTextFormField(
                                  width: kWidth(300),
                                  // height: kHeight(50),
                                  hint: 'البريد الإلكتروني او رقم الهاتف',
                                  controller: emailController,
                                ),
                                SizedBox(height: kHeight(18)),

                                // password text field
                                CustomLoginTextFormField(
                                  width: kWidth(300),
                                  // height: kHeight(50),
                                  hint: 'كلمة المرور',
                                  obscureText: true,
                                  controller: passwordController,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: kHeight(40)),
                          // login button
                          GestureDetector(
                            onTap: () {
                              // for hideing the keyboard
                              FocusScope.of(context).unfocus();

                              // enmail validation
                              String? emailError = _validateEmail(
                                emailController.text,
                              );
                              if (emailError != null) {
                                _showErrorSnackBar(emailError);
                                return; 
                              }

                              // password validation
                              String? passwordError = _validatePassword(
                                passwordController.text,
                              );
                              if (passwordError != null) {
                                _showErrorSnackBar(passwordError);
                                return; 
                              }

                              try {
                                // Process login data here (Firebase Auth or API)
                                print("Login Success... Proceeding");
                              } catch (e) {
                                _showErrorSnackBar("حدث خطأ غير متوقع");
                              }
                            },
                            child: Container(
                              height: kHeight(60),
                              width: kWidth(300),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                color: Colors.orange,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: Center(
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
                          // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل كلمة المرور';
    }
    return null;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
