import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/components/customt_login_text_form_field.dart';
import 'package:khedma/components/custum_backgrond_color.dart';
import 'package:khedma/components/custum_backgrond_image.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/auth_cubit/auth_cubit.dart';
import 'package:khedma/services/auth_service.dart';
import 'package:khedma/services/user_service.dart';

class RecoveryFlow extends StatefulWidget {
  const RecoveryFlow({super.key});
  static String id = 'RecoveryFlow';

  @override
  State<RecoveryFlow> createState() => _RecoveryFlowState();
}

class _RecoveryFlowState extends State<RecoveryFlow> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);

    // RecoveryFlow is a separate route — provides its own AuthCubit.
    return BlocProvider(
      create: (_) => AuthCubit(
        authService: AuthService(),
        userService: UserService(),
      ),
      child: BlocConsumer<AuthCubit, AuthStates>(
        // Rebuild only when loading status flips.
        buildWhen: (prev, curr) =>
            (prev is AuthLoadingState) != (curr is AuthLoadingState),
        // Listen only to operation outcomes.
        listenWhen: (prev, curr) =>
            curr is AuthPasswordResetSentState || curr is AuthErrorState,
        listener: (context, state) {
          if (state is AuthPasswordResetSentState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('تم إرسال رابط إعادة تعيين كلمة المرور على بريدك'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is AuthLoadingState;

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
                          bottom: kHeight(40) +
                              MediaQuery.of(context).viewInsets.bottom,
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

                              _button(
                                isLoading: isLoading,
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    context
                                        .read<AuthCubit>()
                                        .sendPasswordReset(
                                          email: emailController.text,
                                        );
                                  }
                                },
                              ),

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
        },
      ),
    );
  }

  // ─── UI Helpers ───────────────────────────────────────────────────────────

  Widget _title() {
    return const Text(
      'إسترجاع كلمة المرور',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
    );
  }

  Widget _button({
    required VoidCallback onTap,
    required bool isLoading,
  }) {
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

  // ─── Validator ────────────────────────────────────────────────────────────

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'ادخل البريد الإلكتروني';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'ادخل بريد إلكتروني صحيح';
    }
    return null;
  }
}
