// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/controllers/current_skill/current_skill/current_skill_controller.dart';
import 'package:myskills_app/controllers/delete_skill/delete_skill_controller.dart';
import 'package:myskills_app/controllers/home/home_controller.dart';
import 'package:myskills_app/util/custom_snack_bar.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String skillId; // get the skill id from the caller.
  const DeleteConfirmationDialog({super.key, required this.skillId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteSkillCubit, DeleteSkillState>(
      listener: (context, state) {
        // show dialog when state is loading.
        if (state is DeleteLoading) {
          const Center(child: CircularProgressIndicator());
        }
        // show a success message when state is success.
        else if (state is DeleteSuccess) {
          showCustomSnackBar(context, state.successMessage);
          // pop the dialog.
          Navigator.of(context, rootNavigator: true).pop();          
        }
        // show a failure message when state is failure.
        else if (state is DeleteFailure) {
          showCustomSnackBar(context, state.failureMessage, success: false);
        }
      },
      // build the delete UI.
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          title: Align(
            alignment: Alignment.topCenter,
            child: Text('Delete skill'),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 25,
          ), // You really want to delete the skill?
          content: SizedBox(
            height: 100,
            child: Column(
              children: [
                // are you sure?
                Text('Are you sure you want to delete this skill?'),
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

                    // delete, button.
                    TextButton(
                      onPressed: () {
                        // send the skill id as an argument to delete it.
                        context.read<DeleteSkillCubit>().deleteSkill(skillId).then((_){
                          // refresh the home page.
                          context.read<HomeCubit>().fetchSkills();
                          // refresh the current skill
                          context.read<CurrentSkillCubit>().fetchCurrentSkill();
                        });
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
