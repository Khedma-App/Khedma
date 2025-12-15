// import 'package:flutter/material.dart';
// import 'package:khedma/components/build_toggle_item.dart';
// import 'package:khedma/core/constants.dart';

// class BuildToggleButtons extends StatefulWidget {
//   BuildToggleButtons({required this.isLogin, super.key});
//   bool isLogin;

//   @override
//   State<BuildToggleButtons> createState() => _BuildToggleButtonsState();
// }

// class _BuildToggleButtonsState extends State<BuildToggleButtons> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: kWidth(330),
//       height: kHeight(50),
//       decoration: const BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Color.fromRGBO(0, 0, 0, 0.25),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//         borderRadius: BorderRadius.all(Radius.circular(50)),
//         color: Colors.white,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           BuildToggleItem(
//             text: 'تسجيل الدخول',
//             isActive: widget.isLogin,
//             onTap: () => setState(() => widget.isLogin = true),
//           ),
//           BuildToggleItem(
//             text: 'إنشاء حساب',
//             isActive: !widget.isLogin,
//             onTap: () => setState(() => widget.isLogin = false),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:khedma/components/build_toggle_item.dart';
import 'package:khedma/components/service_options_boutton.dart';
import 'package:khedma/core/constants.dart';

// 1. حولناها لـ Stateless لأنها مش هتحتفظ بحالة لنفسها
class BuildToggleButtons extends StatelessWidget {
  const BuildToggleButtons({
    required this.isLogin,
    required this.onToggle, // 2. ضفنا دالة عشان نبلغ الأب
    super.key,
  });

  final bool isLogin;
  final Function(bool)
  onToggle; // الدالة دي بتاخد true لو دخول و false لو تسجيل

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
            isActive: isLogin, // بنستخدم المتغير اللي جاي من فوق
            onTap: () {
              // بدل setState، بننادي الدالة اللي الأب باعتها
              onToggle(true);
            },
          ),
          BuildToggleItem(
            text: 'إنشاء حساب',
            isActive: !isLogin, // عكس الحالة
            onTap: () {
              // بدل setState، بننادي الدالة اللي الأب باعتها
              onToggle(false);
            },
          ),
        ],
      ),
    );
  }
}
