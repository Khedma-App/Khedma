import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/components/customt_login_text_form_field.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/auth_cubit/auth_cubit.dart';
import 'package:khedma/screens/auth_screens/auth_wrapper.dart';
import 'package:khedma/services/auth_service.dart';
import 'package:khedma/services/user_service.dart';

class ServiceRequesterRegisterScreen extends StatefulWidget {
  const ServiceRequesterRegisterScreen({super.key});

  static String id = 'ServiceProviderInformation';

  @override
  State<ServiceRequesterRegisterScreen> createState() =>
      _ServiceRequesterRegisterScreenState();
}

class _ServiceRequesterRegisterScreenState
    extends State<ServiceRequesterRegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedGender;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This screen is a separate route, so it provides its own AuthCubit.
    return BlocProvider(
      create: (_) => AuthCubit(
        authService: AuthService(),
        userService: UserService(),
      ),
      child: BlocConsumer<AuthCubit, AuthStates>(
        // Rebuild only when the loading status flips.
        buildWhen: (prev, curr) =>
            (prev is AuthLoadingState) != (curr is AuthLoadingState),

        // Listen only to operation outcomes.
        listenWhen: (prev, curr) =>
            curr is AuthSignUpSuccessState || curr is AuthErrorState,

        listener: (context, state) {
          if (state is AuthSignUpSuccessState) {
            _showResultDialog(
              context,
              'تم إرسال رابط التحقق إلى بريدك الإلكتروني\nيرجى تفعيل الحساب ثم تسجيل الدخول',
              DialogType.success,
            );
          } else if (state is AuthErrorState) {
            _showResultDialog(context, state.message, DialogType.error);
          }
        },

        builder: (context, state) {
          final bool isLoading = state is AuthLoadingState;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: const BoxDecoration(
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
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            const Spacer(),
                            Column(
                              children: [
                                Container(
                                  width: kScreenWidth,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        children: [
                                          SizedBox(height: kHeight(29)),

                                          // title
                                          const Text(
                                            'طالب خِدمة',
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
                                                keyboardType:
                                                    TextInputType.name,
                                                hint: 'الاســم الاخير',
                                                controller:
                                                    lastNameController,
                                                validator: _validateLastName,
                                                isCenter: true,
                                                width: kWidth(160),
                                              ),

                                              SizedBox(width: kWidth(9)),

                                              // first name
                                              CustomLoginTextFormField(
                                                keyboardType:
                                                    TextInputType.name,
                                                hint: 'الاســم الاول',
                                                controller:
                                                    firstNameController,
                                                validator: _validateFirstName,
                                                isCenter: true,
                                                width: kWidth(160),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: kHeight(20)),

                                          // email
                                          CustomLoginTextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            hint: 'البريد الالكتروني',
                                            controller: emailController,
                                            validator: _validateEmail,
                                            width: kWidth(329),
                                            icon: Container(
                                              padding:
                                                  const EdgeInsets.all(10.0),
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
                                            icon: const Icon(Icons.lock),
                                          ),

                                          SizedBox(height: kHeight(20)),

                                          // gender
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 31.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: kWidth(155),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      12,
                                                    ),
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
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value: selectedGender,
                                                    decoration:
                                                        InputDecoration(
                                                      errorStyle:
                                                          const TextStyle(
                                                        height: 0,
                                                        color:
                                                            Colors.transparent,
                                                        fontSize: 0,
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.red,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      suffixIcon:
                                                          const SizedBox
                                                              .shrink(),
                                                      prefixIcon: const Icon(
                                                        Icons.arrow_drop_down,
                                                        color:
                                                            Color(0xFF434343),
                                                      ),
                                                      border:
                                                          InputBorder.none,
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                                    dropdownColor:
                                                        Colors.white,
                                                    hint: const Text(
                                                      'النـــــوع',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0x80838383),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    items: ['ذكر', 'أنثى']
                                                        .map((String value) {
                                                      return DropdownMenuItem<
                                                          String>(
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
                                                      context
                                                          .read<AuthCubit>()
                                                          .registerRequester(
                                                            firstName:
                                                                firstNameController
                                                                    .text
                                                                    .trim(),
                                                            lastName:
                                                                lastNameController
                                                                    .text
                                                                    .trim(),
                                                            email:
                                                                emailController
                                                                    .text
                                                                    .trim(),
                                                            password:
                                                                passwordController
                                                                    .text
                                                                    .trim(),
                                                            gender:
                                                                selectedGender!,
                                                          );
                                                    }
                                                  },
                                            child: Container(
                                              height: kHeight(60),
                                              width: kWidth(300),
                                              margin: const EdgeInsets.only(
                                                bottom: 28,
                                              ),
                                              decoration: BoxDecoration(
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black38,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                                color: Colors.orange,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(30),
                                                ),
                                              ),
                                              child: Center(
                                                child: isLoading
                                                    ? const CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 3,
                                                      )
                                                    : const Text(
                                                        'متابعة',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 26,
                                                          fontWeight:
                                                              FontWeight.w900,
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
                                ),
                              ],
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
        },
      ),
    );
  }

  // ─── Dialog helper ────────────────────────────────────────────────────────

  void _showResultDialog(
    BuildContext context,
    String message,
    DialogType type,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.scale,
      title: 'تنبيه',
      desc: message,
      btnOkOnPress: () {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AuthWrapper()),
            (route) => false,
          );
        }
      },
    ).show();
  }

  // ─── Validators ───────────────────────────────────────────────────────────

  String? _validateGender(String? value) {
    if (value == null || value.isEmpty) return 'من فضلك اختر النوع';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'ادخل البريد الالكتروني';
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'الرجاء إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) return 'ادخل الاسم الأول';
    if (value.length < 2) return 'الاسم الأول قصير جداً';
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) return 'ادخل الاسم الأخير';
    if (value.length < 2) return 'الاسم الأخير قصير جداً';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'ادخل كلمة مرور';
    if (value.length < 6) return 'كلمة المرور قصيرة جداً';
    return null;
  }
}
