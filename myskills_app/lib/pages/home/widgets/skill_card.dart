import 'package:flutter/material.dart';
import 'package:myskills_app/core/resources/colors.dart';

class SkillCard extends StatelessWidget {
  final Widget child;
  final double height, width; // sometimes I want the card bigger or smaller.
  const SkillCard({
    super.key,
    required this.child,
    this.height = 150,
    this.width = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.white70,
          ColorsManager.homeWidgetsColor
        ]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.amberAccent.shade100, blurRadius: 8),
        ],
      ),
      child: child,
    );
  }
}
