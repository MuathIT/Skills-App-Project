// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/controllers/current_skill/current_skill/current_skill_controller.dart';
import 'package:myskills_app/controllers/home/home_controller.dart';
import 'package:myskills_app/util/custom_snack_bar.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String skillId; // get the skill id from the caller.
  const DeleteConfirmationDialog({super.key, required this.skillId});

  @override
  Widget build(BuildContext context) {
    // this method will delete the skill.
    void deleteSkill (){
      context.read<HomeCubit>().deleteSkill(skillId);
      context.read<CurrentSkillCubit>().fetchCurrentSkill();
    }
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        // show a success message when state is success.
         if (state is HomeSuccess || state is HomeEmpty) {
          showCustomSnackBar(context, 'The skill has been deleted successfully');
          // pop the dialog.
          Navigator.pop(context);        
        }
        // show a failure message when state is failure.
        else if (state is HomeFailure) {
          showCustomSnackBar(context, state.failureMessage, success: false);
        }
      },
      // build the delete UI.
      child: AlertDialog(
          backgroundColor: Colors.white70,
          title: Align(
            alignment: Alignment.topCenter,
            child: Text('Delete skill'),
          ),
          contentPadding: EdgeInsets.all(16), // You really want to delete the skill?
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
                        // delete the skill.
                        deleteSkill();
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
        )
    );
  }
}
