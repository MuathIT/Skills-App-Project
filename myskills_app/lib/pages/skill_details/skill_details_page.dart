import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/controllers/current_skill/current_skill/current_skill_controller.dart';
import 'package:myskills_app/controllers/current_skill/current_skill/update_current_skill_controller.dart';
import 'package:myskills_app/core/data/user_id.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/home/widgets/skill_card.dart';
import 'package:myskills_app/util/custom_snack_bar.dart';

class SkillDetailsPage extends StatelessWidget {
  final Map<String, dynamic> skill;
  const SkillDetailsPage({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdateCurrentSkillCubit(),
      child: SkillDetailsScreen(skill: skill),
    );
  }
}

class SkillDetailsScreen extends StatelessWidget {
  // get the skill details from the privous page.
  final Map<String, dynamic> skill;
  const SkillDetailsScreen({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorsManager.profilePageBacgroundColor,
      child: SkillCard(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white70, ColorsManager.homeWidgetsColor],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
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
                child: BlocConsumer<UpdateCurrentSkillCubit, UpdateCurrentSkillState>(
                  listener: (context, state) {
                    // show dialog when update is loading.
                    if (state is UpdateLoading){
                      const Center(child: CircularProgressIndicator());
                    }
                    // show a success snack bar when update succeeded.
                    else if (state is UpdateSuccess){
                      showCustomSnackBar(context, state.successMessage);
                      // get back to the skills page.
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                    // show a failure snack bar when update failed.
                    else if (state is UpdateFailure){
                      showCustomSnackBar(context, state.failureMessage, success: false);
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                       
                        // onTap? invoke the update current skill function from cubit.
                        context.read<UpdateCurrentSkillCubit>().updateCurrentSkill(
                          UserHelper.uid!,
                          skill['skillId']
                        );
                        // refresh the current skill. 
                        context.read<CurrentSkillCubit>().fetchCurrentSkill(UserHelper.uid!);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColorsManager.backgroundColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "Make it my current skill",
                            style: TextStyle(
                              color: ColorsManager.homeWidgetsColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
