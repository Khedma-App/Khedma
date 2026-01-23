import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/components/build_toggle_buttons.dart';
import 'package:khedma/components/login_form.dart';
import 'package:khedma/components/register_options.dart';
import 'package:khedma/cubits/auth_cubit/auth_cubit.dart';
import 'package:khedma/cubits/auth_cubit/auth_states.dart';
import 'package:khedma/core/constants.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  static String id = 'auth-screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
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
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const Spacer(),
                        Container(
                          width: kScreenWidth,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x00E19113), Color(0xbbEF9B17)],
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: kHeight(50)),
                              Container(
                                width: kScreenWidth,
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(
                                    context,
                                  ).viewInsets.bottom,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 29,
                                    bottom: 35,
                                  ),

                                  child: BlocBuilder<AuthCubit, AuthStates>(
                                    builder: (context, state) {
                                      bool isLogin = state is AuthLoginState;

                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // toggle buttons (login / register)
                                          BuildToggleButtons(
                                            isLogin: isLogin,
                                            onToggle: (val) {
                                              if (val) {
                                                context
                                                    .read<AuthCubit>()
                                                    .switchToLogin();
                                              } else {
                                                context
                                                    .read<AuthCubit>()
                                                    .switchToRegister();
                                              }
                                            },
                                          ),

                                          SizedBox(height: kHeight(40)),

                                          AnimatedCrossFade(
                                            firstChild: const LoginForm(),
                                            secondChild:
                                                const RegisterOptions(),
                                            crossFadeState: isLogin
                                                ? CrossFadeState.showFirst
                                                : CrossFadeState.showSecond,
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                          ),

                                          SizedBox(height: kHeight(20)),
                                        ],
                                      );
                                    },
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
      ),
    );
  }
}
