import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/controllers/completed_skills/completed_skills_controller.dart';
import 'package:myskills_app/controllers/current_skill/current_skill/current_skill_controller.dart';
import 'package:myskills_app/controllers/home/home_controller.dart';
import 'package:myskills_app/util/custom_snack_bar.dart';

class SkillCompletedConfirmation extends StatelessWidget {
  final String skillId;
  const SkillCompletedConfirmation({super.key, required this.skillId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        // empty state here like success state.
        if (state is HomeSuccess || state is HomeEmpty){
          showCustomSnackBar(context, "The skill has been marked as successfully");
          // fetch the current skill to remove the skill from the progress box.
          context.read<CurrentSkillCubit>().fetchCurrentSkill();
          // fetch the completed skills to add the skill to the profile page.
          context.read<CompletedSkillsCubit>().fetchCompletedSkills();
          // pop the dialog.
          Navigator.pop(context);
        }
        else if (state is HomeFailure){
          showCustomSnackBar(context, state.failureMessage, success: false);
        }
      },
      child: AlertDialog(
        backgroundColor: Colors.white70,
        title: Text(
          'Wanna mark the skill as completed?',
          textAlign: TextAlign.center,
        ),
        contentPadding: EdgeInsets.all(
          16,
        ),
        content: SizedBox(
          height: 100,
          child: Column(
            children: [

              Spacer(),
              // answers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // cancel, button.
                  TextButton(
                    onPressed: () {
                      // close the dialog.
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  ),

                  // complete, button.
                  TextButton(
                    onPressed: () {
                      context.read<HomeCubit>().markSkillAsCompleted(skillId);
                    },
                    child: Text(
                      'Complete',
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
