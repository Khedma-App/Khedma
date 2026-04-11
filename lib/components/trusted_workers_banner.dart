import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';

/// Orange promotional banner: "عمال ذات ثقة وبدون عمولة".
class TrustedWorkersBanner extends StatelessWidget {
  const TrustedWorkersBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kWidth(340),
      height: kHeight(46),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(225, 145, 19, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Image.asset(
              'assets/images/check.png',
              width: kWidth(40),
            ),
          ),
          Text(
            'عمال ذات ثقة وبدون عمولة ',
            style: TextStyle(
              fontSize: kSize(17),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
