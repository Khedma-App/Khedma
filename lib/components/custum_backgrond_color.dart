import 'package:flutter/material.dart';

class CustumBackgrondColor extends StatelessWidget {
  const CustumBackgrondColor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x00E19113), Color(0xFFEF9B17)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
