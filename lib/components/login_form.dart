import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/components/customt_login_text_form_field.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/auth_cubit/auth_cubit.dart';
import 'package:khedma/screens/auth_screens/recovery_flow.dart';
import 'package:khedma/screens/auth_screens/service_provider_screen.dart';
import 'package:khedma/screens/main_layout_screen.dart';

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
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      // ✅ Rebuild ONLY when the loading status flips — never for tab/error states.
      buildWhen: (prev, curr) =>
          (prev is AuthLoadingState) != (curr is AuthLoadingState),

      // ✅ Listen ONLY to operation outcomes — routing and error display.
      listenWhen: (prev, curr) =>
          curr is AuthLoginSuccessState || curr is AuthErrorState,

      listener: (context, state) {
        if (state is AuthLoginSuccessState) {
          // Native routing is correctly handled by AuthWrapper via stream listeners.
        } else if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },

      builder: (context, state) {
        final bool isLoading = state is AuthLoadingState;

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
                        color: const Color(0xFFE19113),
                        fontSize: kSize(14),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: kHeight(29)),

              // Login Button
              GestureDetector(
                onTap: isLoading
                    ? null
                    : () {
                        FocusScope.of(context).unfocus();
                        if (formKey.currentState!.validate()) {
                          context.read<AuthCubit>().login(
                                email: emailController.text,
                                password: passwordController.text,
                              );
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
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                        : const Text(
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
      },
    );
  }

  // ─── Validators (UI logic — stays here) ──────────────────────────────────

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'ادخل البريد الإلكتروني';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'ادخل بريد إلكتروني صحيح';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'ادخل كلمة المرور';
    if (value.length < 6) return 'كلمة المرور قصيرة جداً';
    return null;
  }
}
