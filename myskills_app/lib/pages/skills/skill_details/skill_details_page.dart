import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/controllers/current_skill/current_skill/current_skill_controller.dart';
import 'package:myskills_app/controllers/home/home_controller.dart';
import 'package:myskills_app/controllers/profile/profile_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/home/widgets/skill_card.dart';
import 'package:myskills_app/util/custom_snack_bar.dart';

class SkillDetailsPage extends StatefulWidget {
  // get the skill details from the privous page.
  final Map<String, dynamic> skill;
  const SkillDetailsPage({super.key, required this.skill});

  @override
  State<SkillDetailsPage> createState() => _SkillDetailsScreenState();
}

class _SkillDetailsScreenState extends State<SkillDetailsPage> {
  // this variable will open a new text field for the new level.
  bool showNewLevelTextField = false;
  // levels list.
  final List<String> _levels = ['Junior', 'Intermediate', 'Master'];
  // the selected level index.
  String? selectedLevel;

  @override
  Widget build(BuildContext context) {
    // this variable will store the selected skill id.
    final skillId = widget.skill['skillId'];

    // this method will change the user currentSkill.
    void changeUserSkill() {
      context.read<CurrentSkillCubit>().updateCurrentSkill(skillId);
      // refresh the current skill.
    }

    // this method will change the user skill level.
    void changeUserLevel() {
      context.read<HomeCubit>().updateSkillLevel(skillId, selectedLevel!);
    }

    return BlocConsumer<CurrentSkillCubit, CurrentSkillState>(
      listener: (context, state) {
        // show a success snack bar when update succeeded.
        if (state is CurrentSkillSuccess) {
          // close the dialog.
          Navigator.pop(context);
          showCustomSnackBar(
            context,
            'Your current skill has been changed successfully.',
          );
        }
        // show a failure snack bar when update failed.
        else if (state is CurrentSkillFailure) {
          showCustomSnackBar(context, state.failureMessage, success: false);
        }
      },
      builder: (context, state) {
        return Dialog(
          backgroundColor: ColorsManager.profilePageBacgroundColor,
          child: SingleChildScrollView(
            child: SkillCard(
              height: 275,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  // skill name.
                  Text(
                    'Skill: ${widget.skill['name']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  // skill level.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Level: ${widget.skill['level']}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // update level button.
                      IconButton(
                        onPressed: () {
                          setState(() {
                            // show the new level text field.
                            showNewLevelTextField = true;
                          });
                        },
                        icon: const Icon(Icons.edit, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                  // if the user pressed the edit button, show new level text field.
                  showNewLevelTextField
                      ? BlocListener<HomeCubit, HomeState>(
                          listener: (context, state) {
                            if (state is HomeSuccess){
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                            else if (state is HomeFailure){
                              showCustomSnackBar(context, state.failureMessage, success: false);
                            }
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Choose your level:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white60,
                                        ColorsManager.homeWidgetsColor,
                                      ],
                                    ),
                                  ),

                                  // levels list buttons.
                                  child: ListView(
                                    children: [
                                      // Junior button.
                                      RadioListTile(
                                        value:
                                            _levels[0], // the value index in the list.
                                        title: Text(
                                          _levels[0],
                                        ), // tile title (Junior).
                                        groupValue:
                                            selectedLevel, // the detector that checks if the button is selected by comparing the value is equal to groupValue.
                                        onChanged: (value) {
                                          setState(() {
                                            selectedLevel =
                                                value!; // make it the selected level.
                                          });
                                        },
                                      ),

                                      const SizedBox(height: 5),

                                      // Intermediate button.
                                      RadioListTile(
                                        value:
                                            _levels[1], // the value index in the list.
                                        title: Text(
                                          _levels[1],
                                        ), // tile title (Intermediate).
                                        groupValue:
                                            selectedLevel, // the detector that checks if the button is selected by comparing the value is equal to groupValue.
                                        onChanged: (value) {
                                          setState(() {
                                            selectedLevel =
                                                value!; // make it the selected level.
                                          });
                                        },
                                      ),

                                      const SizedBox(height: 5),

                                      // Master button.
                                      RadioListTile(
                                        value:
                                            _levels[2], // the value index in the list.
                                        title: Text(
                                          _levels[2],
                                        ), // tile title (Master).
                                        groupValue:
                                            selectedLevel, // the detector that checks if the button is selected by comparing the value is equal to groupValue.
                                        onChanged: (value) {
                                          setState(() {
                                            selectedLevel =
                                                value!; // make it the selected level.
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 15),

                                // save, cancel buttons.
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // cancel
                                    Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: BoxBorder.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            // return to make it my current skill button.
                                            showNewLevelTextField = false;
                                          });
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 15),

                                    // save.
                                    Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: BoxBorder.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            // change the user level.
                                            changeUserLevel();
                                            showNewLevelTextField = false;
                                          });
                                        },
                                        child: Text(
                                          'Save',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                      )
                      // else, check if this skill card is the user current skill? hide make it my current skill button.
                      // I used a bloc builder here to handle if the user change he's current skill.
                      : BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (_, state) {
                            if (state is ProfileSuccess) {
                              // get the current skill id.
                              final currentSkillId =
                                  state.user['currentSkillId'];
                              // check if this skill card is the user current skill.
                              final isTheCurrentSkill =
                                  currentSkillId == widget.skill['skillId'];
                              return isTheCurrentSkill
                                  ? SizedBox()
                                  : GestureDetector(
                                      onTap: () {
                                        // onTap? update the current skill.
                                        changeUserSkill();
                                        // refresh the user info.
                                        context.read<ProfileCubit>().userInfo();
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: ColorsManager.barColor,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Make it my current skill",
                                            style: TextStyle(
                                              color: ColorsManager
                                                  .homeWidgetsColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.white70,
                                                  blurRadius: 12,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                            }
                            return SizedBox();
                          },
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
