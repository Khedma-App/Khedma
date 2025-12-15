import 'package:flutter/material.dart';
import 'package:khedma/components/build_toggle_item.dart';
import 'package:khedma/core/constants.dart';

class BuildToggleButtons extends StatelessWidget {
  const BuildToggleButtons({
    required this.isLogin,
    required this.onToggle, 
    super.key,
  });

  final bool isLogin;
  final Function(bool)
  onToggle; 

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
            text: 'تسجيل الدخول',
            isActive: isLogin,
            onTap: () {
              onToggle(true);
            },
          ),
          BuildToggleItem(
            text: 'إنشاء حساب',
            isActive: !isLogin,
            onTap: () {
              onToggle(false);
            },
          ),
        ],
      ),
    );
  }
}
