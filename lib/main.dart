import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/screens/auth_screen.dart';
import 'package:khedma/screens/recovery_flow.dart';
import 'package:khedma/screens/service_requester_register_screen.dart';
import 'package:khedma/screens/service_provider_register_screen.dart';
import 'package:khedma/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          return WelcomeScreen();
        },
      ),
    );
  }
}
