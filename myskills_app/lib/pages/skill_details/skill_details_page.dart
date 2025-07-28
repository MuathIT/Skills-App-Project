import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/models/skill/skill_model.dart';
import 'package:myskills_app/pages/home/widgets/skill_card.dart';

class SkillDetailsPage extends StatelessWidget {
  // get the skill details from the privous page.
  final Map<String, dynamic> skill;
  const SkillDetailsPage({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorsManager.profilePageBacgroundColor,
      child: SkillCard(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white70, ColorsManager.homeWidgetsColor],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // skill name.
              Text(
                skill['name'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // skill level.
              Text(
                skill['level'],
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Spacer(),

              // make it the current skill button.  
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: ColorsManager.progressCircleColor,
                      borderRadius: BorderRadius.circular(16)
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
