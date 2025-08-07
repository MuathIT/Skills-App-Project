
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/controllers/home/home_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/models/skill/skill_model.dart';
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

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeSuccess) {
          showCustomSnackBar(context, 'The skill has been add successfully');
          // pop the dialog.
          Navigator.pop(context);
          // clear the controller.
          _skillNamecontroller.clear();
        } else if (state is HomeFailure) {
          showCustomSnackBar(context, state.failureMessage, success: false);
        }
      },

      // build the card.
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: ColorsManager.homeWidgetsColor,
          title: Text(
            'Add a new skill',
            textAlign: TextAlign.center,
            style: GoogleFonts.bebasNeue(
              color: Colors.black,
              fontSize: 32
            ),
          ),
          contentPadding: EdgeInsets.all(0),
          content: Container(
            height: 275,
            width: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
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
              
                  Spacer(),

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
                        // add the skill.
                        context.read<HomeCubit>().addSkill(s);
                      },
                      child: Container(
                        height: 45,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            // bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Icon(
                          Icons.add_box_outlined,
                          color: ColorsManager.homeWidgetsColor,
                          size: 40,
                        ),
                      ),
                    ),
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
