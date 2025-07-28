import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/home/widgets/skill_card.dart';
import 'package:myskills_app/pages/skill_details/skill_details_page.dart';

class SkillsPage extends StatelessWidget {
  // get the user skills from home page.
  final List<Map<String, dynamic>> skills;
  const SkillsPage({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'My skills',
          style: GoogleFonts.mPlus1p(
            color: ColorsManager.homeWidgetsColor,
            fontSize: 24
          ),
        ),
      ),
      body: SafeArea(
        // page grid.
        child: GridView.builder(
          itemCount: skills.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // this will build two box in each row.
            crossAxisSpacing: 25, // the horziontal space between each row.
            mainAxisSpacing: 10, // the vertical space between each row.
          ),
          padding: EdgeInsets.all(16),
          // the skills cards.
          itemBuilder: (_, index) {
            // store the current index skill.
            final skill = skills[index];
            
            return GestureDetector(
              // onTap? show a dialog that has the skill details.
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => SkillDetailsPage(skill: skill) // pass the current skill to the page. We will use it there.
                );
              },
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // skill name.
                      Text(
                        skill['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
