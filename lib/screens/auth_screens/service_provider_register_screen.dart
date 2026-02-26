import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khedma/components/customt_login_text_form_field.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/screens/auth_screens/auth_screen.dart';

class ServiceProviderRegisterScreen extends StatefulWidget {
  const ServiceProviderRegisterScreen({super.key});
  static String id = 'service-provider-register-screen';
  @override
  State<ServiceProviderRegisterScreen> createState() =>
      _ServiceProviderRegisterScreenState();
}

class _ServiceProviderRegisterScreenState
    extends State<ServiceProviderRegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? selectedGender;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bac.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Spacer(),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              width: kScreenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                              ),
                              child: SingleChildScrollView(
                                physics: ClampingScrollPhysics(),
                                child: Column(
                                  children: [
                                    SizedBox(height: kHeight(29)),
                                    // title
                                    Text(
                                      'مُقدم خِدمة',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: kHeight(39)),

                                    // name row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // last name
                                        CustomLoginTextFormField(
                                          keyboardType: TextInputType.name,

                                          hint: 'الاســم الاخير',
                                          isCenter: true,
                                          validator: _validateLastName,
                                          controller: lastNameController,
                                          width: kWidth(160),
                                          // hight: kHeight(42),
                                        ),
                                        SizedBox(width: kWidth(9)),
                                        // first name
                                        CustomLoginTextFormField(
                                          keyboardType: TextInputType.name,

                                          hint: 'الاســم الاول',
                                          isCenter: true,
                                          controller: firstNameController,
                                          validator: _validateFirstName,
                                          width: kWidth(160),
                                          // hight: kHeight(42),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: kHeight(20)),

                                    // phone
                                    CustomLoginTextFormField(
                                      keyboardType: TextInputType.number,

                                      hint: 'البريد الالكتروني',
                                      controller: emailController,
                                      validator: _validateEmail,
                                      width: kWidth(329),
                                      // hight: kHeight(42),
                                      icon: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        width: kWidth(22),
                                        child: Image.asset(
                                          'assets/images/egypt-image.png',
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: kHeight(20)),
                                    // password
                                    CustomLoginTextFormField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      hint: 'كلمــــــــة المــــــــرور',
                                      controller: passwordController,
                                      validator: _validatePassword,
                                      width: kWidth(329),
                                      // hight: kHeight(42),
                                      icon: Icon(Icons.lock),
                                    ),
                                    SizedBox(height: kHeight(20)),
                                    // gender and age row
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 31.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // gender
                                          Container(
                                            width: kWidth(155),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                    0,
                                                    0,
                                                    0,
                                                    0.25,
                                                  ),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: DropdownButtonFormField<String>(
                                              initialValue: selectedGender,
                                              decoration: InputDecoration(
                                                errorStyle: const TextStyle(
                                                  height: 0,
                                                  color: Colors.transparent,
                                                  fontSize: 0,
                                                ),

                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: const BorderSide(
                                                    color: Colors.red,
                                                    width: 1,
                                                  ),
                                                ),

                                                suffixIcon:
                                                    const SizedBox.shrink(),
                                                prefixIcon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Color(0xFF434343),
                                                ),
                                                border: InputBorder.none,
                                                filled: true,
                                                fillColor: Colors.white,
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                              dropdownColor: Colors.white,
                                              hint: const Text(
                                                'النـــــوع',
                                                style: TextStyle(
                                                  color: Color(0x80838383),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              items: ['ذكر', 'أنثى'].map((
                                                String value,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),

                                              validator: _validateGender,

                                              onChanged: (value) {
                                                setState(() {
                                                  selectedGender = value;
                                                });
                                              },
                                            ),
                                          ),
                                          // age
                                          CustomLoginTextFormField(
                                            keyboardType: TextInputType.number,

                                            hint: 'الســــــن',
                                            isCenter: true,
                                            controller: ageController,
                                            validator: _validateAge,
                                            width: kWidth(160),
                                            // hight: kHeight(42),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: kHeight(72)),
                                    // Continue button
                                    GestureDetector(
                                      onTap: isLoading
                                          ? null
                                          : () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                _registerWithEmail();
                                              }
                                            },
                                      child: Container(
                                        height: kHeight(60),
                                        width: kWidth(300),
                                        margin: const EdgeInsets.only(
                                          bottom: 28,
                                        ),

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
                                          child: isLoading
                                              ? CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 3,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                )
                                              : Text(
                                                  'متابعة',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: kHeight(40)),
                                  ],
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
          },
        ),
      ),
    );
  }

  Future<void> _registerWithEmail() async {
    setState(() {
      isLoading = true;
    });
    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      // 1️⃣ إنشاء الحساب
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User user = credential.user!;

      // 2️⃣ حفظ البيانات في Firestore
      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'role': 'provider', // 👈 نوع المستخدم
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': '', // لو هتضيفه بعدين
        'createdAt': FieldValue.serverTimestamp(),
        'isFirstTime': true,
        'profileCompleted': false,

        // 👨‍🔧 بيانات مقدم الخدمة
        'providerData': {
          'age': int.parse(ageController.text),
          'gender': selectedGender,
          'serviceType': '', // يتحدد لاحقًا
          'rating': 0,
          'completedJobs': 0,
          'isAvailable': true,
        },
      });

      // 3️⃣ إرسال تحقق الإيميل
      await user.sendEmailVerification();

      _showAwesomeDialog(
        'تم إرسال رابط التحقق إلى بريدك الإلكتروني\nيرجى تفعيل الحساب ثم تسجيل الدخول',
        DialogType.success,
      );

      // 4️⃣ تسجيل خروج
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      String msg = 'حدث خطأ';

      if (e.code == 'email-already-in-use') {
        msg = 'الإيميل مستخدم بالفعل';
      } else if (e.code == 'invalid-email') {
        msg = 'الإيميل غير صالح';
      } else if (e.code == 'weak-password') {
        msg = 'كلمة المرور ضعيفة';
      } else if (e.code == 'network-request-failed') {
        msg = 'تحقق من الإنترنت';
      }

      _showAwesomeDialog(msg, DialogType.error);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showAwesomeDialog(String msg, DialogType type) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.scale,
      title: 'تنبيه',
      desc: msg,
      btnOkOnPress: () {
        if (mounted) {
          bool isFirstTime = true;
          Navigator.pushReplacementNamed(context, AuthScreen.id);
        }
      },
    ).show();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل البريد الإلكتروني';
    }

    bool isEmail = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value);

    if (!isEmail) {
      return 'الرجاء إدخال بريد إلكتروني صالح';
    }
    return null;
  }

  String? _validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'من فضلك اختر النوع';
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

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل الاسم الأول';
    } else if (value.length < 2) {
      return 'الاسم الأول قصير جداً';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل السن';
    }

    int? age = int.tryParse(value);
    if (age == null || age < 18 || age > 70) {
      return 'الرجاء إدخال سن صحيح بين 18 و 70';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل الاسم الأخير';
    } else if (value.length < 2) {
      return 'الاسم الأخير قصير جداً';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'ادخل كلمة مرور';
    }
    if (value.length < 6) {
      return 'كلمة المرور قصيرة جداً';
    }
    return null;
  }
}
