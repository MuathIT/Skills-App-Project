import 'package:flutter/material.dart';
import 'package:myskills_app/core/resources/colors.dart';

class SkillCard extends StatelessWidget {
  final Widget child;
  const SkillCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: ColorsManager.homeWidgetsColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.amberAccent.shade100, blurRadius: 8),
        ],
      ),
      child: child,
    );
  }
}
