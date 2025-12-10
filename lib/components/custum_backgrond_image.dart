import 'package:flutter/material.dart';

class CustumBackgrondImage extends StatelessWidget {
  const CustumBackgrondImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset('assets/images/bac.jpg', fit: BoxFit.cover),
    );
  }
}
