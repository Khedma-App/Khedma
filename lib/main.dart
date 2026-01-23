import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/home_cubit/home_cubit.dart';
import 'package:khedma/screens/auth_screens/auth_screen.dart';
import 'package:khedma/screens/main_layout_screen.dart';
import 'package:khedma/screens/auth_screens/recovery_flow.dart';
import 'package:khedma/screens/auth_screens/service_requester_register_screen.dart';
import 'package:khedma/screens/auth_screens/service_provider_register_screen.dart';
import 'package:khedma/screens/auth_screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());

  // set status bar to transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, 
      statusBarIconBrightness: Brightness.dark, 
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => HomeCubit())],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'cairo'),
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          AuthScreen.id: (context) => const AuthScreen(),
          ServiceProviderRegisterScreen.id: (context) =>
              ServiceProviderRegisterScreen(),
          ServiceRequesterRegisterScreen.id: (context) =>
              ServiceRequesterRegisterScreen(),
          RecoveryFlow.id: (context) => RecoveryFlow(),
        },
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            //  context عشان اقدر اوصل للـ Builder هنا انا استخدمت
            // اللي من خلاله هقدر اجيب الطول و العرض بتاع الشاشة
            initScreenSize(context);
            return MainLayoutScreen();
          },
        ),
      ),
    );
  }
}
