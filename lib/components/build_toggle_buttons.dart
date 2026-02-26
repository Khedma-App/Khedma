import 'package:flutter/material.dart';
import 'package:khedma/components/build_toggle_item.dart';
import 'package:khedma/core/constants.dart';

class BuildToggleButtons extends StatelessWidget {
  const BuildToggleButtons({
    required this.isLogin,
    required this.onToggle,
    super.key,
    required this.title1,
    required this.title2,
    this.isRight = false,
  });

  final bool isRight;
  final bool isLogin;
  final String title1;
  final String title2;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kWidth(330),
      height: kHeight(50),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BuildToggleItem(
            text: title1,
            isActive: isRight ? !isLogin : isLogin,
            onTap: () {
              onToggle(isRight ? false : true);
            },
          ),
          BuildToggleItem(
            text: title2,
            isActive: isRight ? isLogin : !isLogin,
            onTap: () {
              onToggle(isRight ? true : false);
            },
          ),
        ],
      ),
    );
  }
}
