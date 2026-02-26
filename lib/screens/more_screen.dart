import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khedma/screens/auth_screens/auth_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المزيد'),
        actions: [
          IconButton(
            onPressed: () {
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, AuthScreen.id);
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
