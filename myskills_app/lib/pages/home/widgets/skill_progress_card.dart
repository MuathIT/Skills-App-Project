


import 'package:flutter/material.dart';
import 'package:myskills_app/core/resources/colors.dart';

// ignore: must_be_immutable
class SkillProgressCard extends StatelessWidget {
  Widget child;
  SkillProgressCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        // color: ColorsManager.progressCircleColor,
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            ColorsManager.progressCircleColor,
            const Color.fromARGB(255, 116, 86, 2),
          ]
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ColorsManager.homeWidgetsColor,
            blurRadius: 15,
          )
        ]
      ),
      child: child,
    );
  }
}