import 'package:flutter/material.dart';
import 'package:khedma/components/build_nav_item.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/home_cubit/home_cubit.dart';

class BuildCustomBottomNavBar extends StatefulWidget {
  BuildCustomBottomNavBar({super.key, required this.cubit});
  HomeCubit cubit;
  @override
  State<BuildCustomBottomNavBar> createState() =>
      _BuildCustomBottomNavBarState();
}

class _BuildCustomBottomNavBarState extends State<BuildCustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: kSize(7)),
        margin: EdgeInsets.symmetric(
          horizontal: kSize(29),
          vertical: kSize(17),
        ),
        height: kHeight(87),
        width: kScreenWidth,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(245, 245, 245, 1),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: BuildNavItem(
                cubit: widget.cubit,
                index: 0,
                icon: Icons.more_horiz,
                label: 'المزيد',
              ),
            ),

            Expanded(
              child: BuildNavItem(
                cubit: widget.cubit,
                index: 1,
                icon: Icons.chat_sharp,
                label: 'المحادثات',
              ),
            ),

            Expanded(
              child: BuildNavItem(
                cubit: widget.cubit,
                index: 2,
                icon: Icons.search,
                label: 'بحث',
              ),
            ),

            Expanded(
              child: BuildNavItem(
                cubit: widget.cubit,
                index: 3,
                icon: Icons.home,
                label: 'الرئيسية',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
