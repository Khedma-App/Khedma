import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khedma/screens/auth_screens/auth_wrapper.dart';
import 'package:khedma/services/auth_service.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المزيد'),
        actions: [
          IconButton(
            onPressed: () async {
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                // 1. Sign out cleanly
                await AuthService().signOut();

                // 2. Kill the entire navigation stack (clearing state memory)
                // and drop the user back at the AuthWrapper.
                // The Wrapper will detect the null user and show AuthScreen.
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const AuthWrapper(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                }
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
