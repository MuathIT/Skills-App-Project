import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/controllers/add_skill/add_skill_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/models/skill/skill_model.dart';
import 'package:myskills_app/pages/home/widgets/skill_card.dart';
import 'package:myskills_app/util/custom_snack_bar.dart';

class AddSkillDialog extends StatefulWidget {
  const AddSkillDialog({super.key});

  @override
  State<AddSkillDialog> createState() => _AddSkillDialogState();
}

class _AddSkillDialogState extends State<AddSkillDialog> {
  // name controller.
  final _skillNamecontroller = TextEditingController();
  // skill levels.
  final List<String> _levels = ['Junior', 'Intermediate', 'Master'];
  // level holder.
  String _selectedLevel = 'Junior';

  @override
  Widget build(BuildContext context) {
    // this method will the send the new skill to the cubit.
    void addSkill(Skill newSkill) {
      context.read<AddSkillCubit>().addSkill(newSkill);
    }

    return BlocConsumer<AddSkillCubit, AddSkillState>(
      listener: (context, state) {
        // show a dialog while loading.
        if (state is AddSkillLoading) {
          showDialog(
            context: context,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        }
        // close the dialog when loading finish.
        else {
          Navigator.of(context, rootNavigator: true).pop();
        }

        if (state is AddSkillSuccess) {
          // clear the controller.
          _skillNamecontroller.clear();
          // tell the user that the skill has been added.
          showCustomSnackBar(context, state.successMessage);
          // get back to the home page.
          Navigator.of(context, rootNavigator: true).pop();
        } else if (state is AddSkillFailure) {
          // tell the user that the skill not added.
          showCustomSnackBar(context, state.failureMessage, success: false);
        }
      },

      // build the card.
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: ColorsManager.homeWidgetsColor,
          title: Text(
            'Add a new skill',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          contentPadding: EdgeInsets.only(top: 20, left: 12),
          content: SizedBox(
            height: 325,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // skill name textField.
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.white60, ColorsManager.homeWidgetsColor],
                    ),
                  ),
                  child: TextField(
                    controller: _skillNamecontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      labelText: "Skill Name",
                      labelStyle: TextStyle(
                        color: Colors.grey[850],
                        fontSize: 18,
                      ),
                      hintText: "Type the skill name..",
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose your level:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // level field.
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.white60, ColorsManager.homeWidgetsColor],
                    ),
                  ),

                  // levels list buttons.
                  child: ListView(
                    children: [
                      // Junior button.
                      RadioListTile(
                        value: _levels[0], // the value index in the list.
                        title: Text(_levels[0]), // tile title (Junior).
                        groupValue:
                            _selectedLevel, // the detector that checks if the button is selected by comparing the value is equal to groupValue.
                        onChanged: (value) {
                          setState(() {
                            _selectedLevel =
                                value!; // make it the selected level.
                          });
                        },
                      ),

                      const SizedBox(height: 5),

                      // Intermediate button.
                      RadioListTile(
                        value: _levels[1], // the value index in the list.
                        title: Text(_levels[1]), // tile title (Intermediate).
                        groupValue:
                            _selectedLevel, // the detector that checks if the button is selected by comparing the value is equal to groupValue.
                        onChanged: (value) {
                          setState(() {
                            _selectedLevel =
                                value!; // make it the selected level.
                          });
                        },
                      ),

                      const SizedBox(height: 5),

                      // Master button.
                      RadioListTile(
                        value: _levels[2], // the value index in the list.
                        title: Text(_levels[2]), // tile title (Master).
                        groupValue:
                            _selectedLevel, // the detector that checks if the button is selected by comparing the value is equal to groupValue.
                        onChanged: (value) {
                          setState(() {
                            _selectedLevel =
                                value!; // make it the selected level.
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // skill image field.
                GestureDetector(
                  onTap: () {},
                  child: DottedBorder(
                    padding: const EdgeInsets.all(8),
                    borderType: BorderType.Circle,
                    dashPattern: const [4, 2],
                    strokeWidth: 2,
                    color: Colors.grey,
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                ),

                // add skill button.
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      // create a new skill.
                      Skill s = Skill(
                        name: _skillNamecontroller.text.toUpperCase(),
                        level: _selectedLevel,
                      );
                      // send the skill.
                      setState(() {
                        addSkill(s);
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: ColorsManager.homeWidgetsColor,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
