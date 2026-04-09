// الموزع الرئيسي للتطبيق
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khedma/screens/auth_screens/auth_screen.dart';
import 'package:khedma/screens/main_layout_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const AuthScreen();
        }

        final user = snapshot.data!;

        // إذا سجل دخول ولكن لم يفعل الإيميل
        if (!user.emailVerified) {
          return const AuthScreen();
        }

        // الدخول للشاشة الرئيسية
        return const MainLayoutScreen();
      },
    );
  }
}
