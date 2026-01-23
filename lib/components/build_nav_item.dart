import 'package:flutter/material.dart';
import 'package:khedma/core/constants.dart';
import 'package:khedma/cubits/home_cubit/home_cubit.dart';

class BuildNavItem extends StatefulWidget {
  const BuildNavItem({
    super.key,
    required this.cubit,
    required this.index,
    required this.icon,
    required this.label,
  });
  final HomeCubit cubit;
  final int index;
  final IconData icon;
  final String label;
  @override
  State<BuildNavItem> createState() => _BuildNavItemState();
}

class _BuildNavItemState extends State<BuildNavItem> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.cubit.currentIndex == widget.index;

    return GestureDetector(
      onTap: () {
        widget.cubit.changeBottomNav(widget.index);
      },
      child: AnimatedContainer(
        width: isSelected ? kWidth(77) : null,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEF9B17) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: isSelected
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: Colors.white, size: 32),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              )
            : Icon(widget.icon, color: Colors.orange, size: 35),
      ),
    );
    ;
  }
}
