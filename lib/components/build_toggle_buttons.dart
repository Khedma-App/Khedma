import 'package:flutter/material.dart';
import 'package:khedma/components/build_toggle_item.dart';
import 'package:khedma/core/constants.dart';

/// A horizontal toggle bar that supports 2 or more labels.
///
/// [activeIndex] controls which tab is highlighted.
/// [onChanged] fires when the user taps a different tab.
class BuildToggleButtons extends StatelessWidget {
  const BuildToggleButtons({
    super.key,
    required this.labels,
    required this.activeIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int activeIndex;
  final ValueChanged<int> onChanged;

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
        children: List.generate(labels.length, (i) {
          return Expanded(
            child: BuildToggleItem(
              text: labels[i],
              isActive: i == activeIndex,
              onTap: () => onChanged(i),
            ),
          );
        }),
      ),
    );
  }
}
