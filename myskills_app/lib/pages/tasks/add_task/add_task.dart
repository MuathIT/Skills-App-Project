import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/controllers/tasks/tasks_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/util/custom_snack_bar.dart';

class AddTask extends StatelessWidget {
  AddTask({super.key});

  // task name controller.
  final _taskNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is TasksSuccess){
          showCustomSnackBar(context, 'The task has been added successfully');
          // pop the dialog.
          Navigator.pop(context);
          // clear the controller.
          _taskNameController.clear();
        }
      },
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: ColorsManager.profilePageBacgroundColor,
          title: Text("Add a new task", textAlign: TextAlign.center),
          titleTextStyle: GoogleFonts.bebasNeue(
            fontSize: 32,
            color: Colors.black,
            // fontWeight: FontWeight.bold
          ),
          contentPadding: EdgeInsets.all(0),
          content: Container(
            height: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // task name field.
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white70,
                          ColorsManager.profilePageBacgroundColor,
                        ],
                      ),
                    ),
                    child: TextField(
                      controller: _taskNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        labelText: 'Task Name',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      cursorColor: Colors.grey,
                    ),
                  ),
                ),

                // add task button.
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      // add the task.
                      context.read<TasksCubit>().addNewTask(
                        _taskNameController.text.trim(),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: ColorsManager.backgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                        ),
                      ),
                      child: const Icon(
                        Icons.add_task,
                        color: ColorsManager.profilePageBacgroundColor,
                        size: 40,
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
