import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/controllers/home/home_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/home/widgets/skill_card.dart';
import 'package:myskills_app/pages/skill_details/skill_details_page.dart';
import 'package:myskills_app/util/delete_confirmation_dialog.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

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
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      // we will build the skills page using home cubit bc it depends entirely on home cubit too.
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          // show loading dialog when state is loading state.
          if (state is HomeLoading){
            return const Center(child: CircularProgressIndicator());
          }
          // display an emptiness message when state is empty state.
          else if (state is HomeEmpty){
            return const Center(
              child: Text(
                "You don't have skills yet",
                style: TextStyle(
                  fontSize: 24,
                  color: ColorsManager.homeWidgetsColor
                ),
              ),
            );
          }
          // get & display the skills when state is success state.
          else if (state is HomeSuccess){
            // get the skills from the state.
            final skills = state.skills;
            return SafeArea(
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

                  // a slidable skill card for deletion. (slid to delete.)
                  return Slidable(
                    direction: Axis.horizontal,
                    endActionPane: ActionPane(
                      motion: StretchMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(16),
                          onPressed: (_) {
                            showDialog(
                              context: context,
                              builder: (_) => DeleteConfirmationDialog(
                                skillId: skill['skillId'],
                              ),
                            );
                          },
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      // onTap? show a dialog that has the skill details.
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => SkillDetailsPage(
                            skill: skill,
                          ), // pass the current skill to the page. We will use it there.
                        );
                      },
                      child: SkillCard(
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
            );
          }
          // display error message when state is failure state.
          else if (state is HomeFailure){
            return Center(
              child: Text(
                state.failureMessage,
                style: TextStyle(color: Colors.red, fontSize: 24),
              ),
            );
          }

          // when state is initial state.
          return const SizedBox();
        }
      ),
    );
  }
}
