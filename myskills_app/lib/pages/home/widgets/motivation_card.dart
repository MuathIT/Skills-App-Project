


import 'package:flutter/material.dart';
import 'package:myskills_app/core/resources/colors.dart';

class MotivationCard extends StatelessWidget {
  const MotivationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white70,
                ColorsManager.homeWidgetsColor
              ]),

              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: ColorsManager.homeWidgetsColor,
                  blurStyle: BlurStyle.solid,
                  blurRadius: 10,
                  // offset: Offset(6, 0)
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Small steps every day lead to big changes over time.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
            ),
          );
  }
}