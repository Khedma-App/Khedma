// الموزع الرئيسي للتطبيق
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khedma/screens/auth_screens/auth_screen.dart';
import 'package:khedma/screens/auth_screens/service_provider_screen.dart';
import 'package:khedma/screens/main_layout_screen.dart';
import 'package:khedma/services/user_service.dart';
import 'package:khedma/models/user_model.dart';

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

        // Fetch User Data to decide routing (Provider vs User)
        return FutureBuilder<UserModel>(
          future: UserService().getUserById(user.uid),
          builder: (context, userSnapshot) {
             if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
             }
             
             if (userSnapshot.hasData) {
                final userModel = userSnapshot.data!;
                // Role-based routing natively handled by wrapper
                if (userModel.isProvider && userModel.isFirstTime) {
                   return const ServiceProviderScreen();
                }
                return const MainLayoutScreen();
             }
             
             // Fallback if document doesn't exist yet (e.g. during sign up flow)
             return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        );
      },
    );
  }
}
