import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart'
    show kDesignHeight, kDesignWidth, kWidth, kHeight;

class CustumBackgrondImage extends StatelessWidget {
  const CustumBackgrondImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kWidth(kDesignWidth),
      height: kHeight(kDesignHeight),
      child: Image.asset('assets/images/bac.jpg', fit: BoxFit.cover),
    );
  }
}
