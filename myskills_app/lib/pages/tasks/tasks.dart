
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/controllers/tasks/tasks_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/tasks/add_task/add_task.dart';
import 'package:myskills_app/util/custom_snack_bar.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            // pop the tasks page.
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: ColorsManager.profilePageBacgroundColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          'My tasks'.toUpperCase(),
          style: GoogleFonts.mPlus1p(
            color: ColorsManager.profilePageBacgroundColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // add task button.
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsManager.profilePageBacgroundColor,
        onPressed: () {
          showDialog(context: context, builder: (_) => AddTask());
        },
        child: const Icon(Icons.add, color: ColorsManager.backgroundColor),
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is TasksLoading) {
            const Center(child: CircularProgressIndicator());
          } else if (state is TasksFailure) {
            showCustomSnackBar(context, state.failureMessage, success: false);
          }
        },
        builder: (context, state) {
          if (state is TasksEmpty) {
            return Center(
              child: Text(
                state.emptyMessage,
                style: TextStyle(
                  fontSize: 28,
                  color: ColorsManager.profilePageBacgroundColor,
                ),
              ),
            );
          } else if (state is TasksSuccess) {
            // get the user tasks.
            final tasks = state.tasks;
            return ListView.separated(
              itemCount: tasks.length,
              separatorBuilder: (_, index) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                // store the current index task to display it.
                final task = tasks[index];
                // task UI.
                return Slidable(
                  endActionPane: ActionPane(
                    motion: StretchMotion(),
                    children: [
                      // delete button.
                      SlidableAction(
                        onPressed: (_) {
                          context.read<TasksCubit>().removeTask(
                            task['taskId'],
                          );
                        },
                        icon: Icons.delete,
                        borderRadius: BorderRadius.circular(16),
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Container(
                      height: 75,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: ColorsManager.profilePageBacgroundColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Checkbox(
                            value: task['isCompleted'] ?? false,
                            onChanged: (newValue) {
                              // toggle the task in the db.
                              context.read<TasksCubit>().toggleTaskCompleted(
                                task['taskId'],
                                newValue!,
                              );
                            },
                          ),
                          Text(
                            task['name'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decoration: task['isCompleted']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          SizedBox(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
