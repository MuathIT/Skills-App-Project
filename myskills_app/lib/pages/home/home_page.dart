import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/controllers/current_skill/current_skill/current_skill_controller.dart';
import 'package:myskills_app/controllers/home/home_controller.dart';
import 'package:myskills_app/controllers/tasks/tasks_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/home/widgets/motivation_card.dart';
import 'package:myskills_app/pages/home/widgets/skillProgress/skill_completed_confirmation.dart';
import 'package:myskills_app/pages/home/widgets/skill_card.dart';
import 'package:myskills_app/pages/home/widgets/skillProgress/skill_progress_card.dart';
import 'package:myskills_app/pages/skills/new_skill/add_skill_dialog.dart';
import 'package:myskills_app/pages/skills/skills_page.dart';
import 'package:myskills_app/pages/tasks/tasks.dart';
import 'package:myskills_app/util/delete_confirmation_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      floatingActionButton: // add new skill button.
      Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          backgroundColor: ColorsManager.homeWidgetsColor,
          hoverColor: Colors.grey[400],
          onPressed: () {
            // show the add skill card dialog.
            showDialog(context: context, builder: (_) => AddSkillDialog());
          },
          child: Icon(Icons.add, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          // home page.
          children: [
            // motivation.
            MotivationCard(),

            const SizedBox(height: 40),

            // Spacer(),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  // empty home.
                  if (state is HomeEmpty) {
                    return SizedBox(
                      height: 500,
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(color: Colors.white, fontSize: 24),
                            children: [
                              TextSpan(text: state.emptyMessage),
                              TextSpan(
                                text: "\nAdd a new skill to get started :)",
                                style: TextStyle(
                                  color: ColorsManager.homeWidgetsColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (state is HomeSuccess) {
                    // get the uncompleted skills.
                    final skills = state.skills;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Current Skill Progress
                        Text(
                          'My Current skill'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 20,
                            color: ColorsManager.homeWidgetsColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        _skillProgressCard(),

                        const SizedBox(height: 40),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // my tasks card.
                            _tasksCard(context),

                            // Spacer(),

                            // my skills card.
                            _skillsCard(context, skills),
                          ],
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Column _skillsCard(BuildContext context, final skills) {
    return Column(
      children: [
        Text(
          'My Skills'.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            color: ColorsManager.homeWidgetsColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        // card UI.
        GestureDetector(
          // onTap? navigate to the skills page.
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => SkillsPage()));
          },
          child: SkillCard(
            width: 170,
            child: ListView.separated(
              itemCount: skills.length,
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemBuilder: (_, index) {
                // store the skill of the current index.
                final skill = skills[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    // skill name.
                    Text(
                      skill['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // delete button.
                    IconButton(
                      // show a confirmation dialog before deletion.
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => DeleteConfirmationDialog(
                            skillId: skill['skillId'],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _tasksCard(BuildContext context) {
    return Column(
      children: [
        Text(
          'My Tasks'.toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            color: ColorsManager.homeWidgetsColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        GestureDetector(
          onTap: () {
            // navigate to the tasks page.
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => TasksPage()));
          },
          child: SkillCard(
            width: 170,
            child: BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                if (state is TasksEmpty) {
                  return Center(
                    child: Text(
                      state.emptyMessage,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else if (state is TasksSuccess) {
                  // get the tasks list from DB.
                  final tasks = state.tasks;
                  // filter the uncompleted tasks.
                  final unCompletedTasks = [];
                  for (var task in tasks) {
                    if (!task['isCompleted']) {
                      unCompletedTasks.add(task);
                    }
                  }
                  // display 3 tasks.
                  return unCompletedTasks.isEmpty
                      ? Center(
                          child: Text(
                            "You have done all your tasks!✅",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 5),
                          itemCount: unCompletedTasks.length > 2
                              ? 3 // display the first 3 uncompleted tasks or if the tasks < 3 display them all.
                              : unCompletedTasks.length,
                          itemBuilder: (_, index) {
                            // store the current index task.
                            final task = unCompletedTasks[index];
                            // display the task name.
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                // skill name.
                                Text(
                                  task['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // delete button.
                                IconButton(
                                  // show a confirmation dialog before deletion.
                                  onPressed: () {
                                    context.read<TasksCubit>().removeTask(
                                      task['taskId'],
                                    );
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            );
                          },
                        );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ],
    );
  }

  SkillProgressCard _skillProgressCard() {
    return SkillProgressCard(
      child: BlocBuilder<CurrentSkillCubit, CurrentSkillState>(
        builder: (context, state) {
          if (state is CurrentSkillEmpty) {
            // display the emptiness message when the state is empty.
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  state.emptyMessage,
                  style: GoogleFonts.acme(
                    color: ColorsManager.homeWidgetsColor,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          // show the skill when it's loaded successfully.
          else if (state is CurrentSkillSuccess) {
            // store the current skill.
            final currentSkill = state.currentSkill;
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => SkillCompletedConfirmation(
                    skillId: currentSkill['skillId'],
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // current skill name.
                  Text(
                    currentSkill['name'].toString().toUpperCase(),
                    style: GoogleFonts.mPlus1Code(
                      fontSize: 24,
                      color: ColorsManager.homeWidgetsColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // current skill level.
                  Text(
                    currentSkill['level'],
                    style: GoogleFonts.mPlus1Code(
                      fontSize: 20,
                      color: ColorsManager.homeWidgetsColor,
                      // fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
          // show an error message when failed to load the skill.
          else if (state is CurrentSkillFailure) {
            return Center(
              child: Text(
                state.failureMessage,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          // show nothing in initial state.
          return const SizedBox();
        },
      ),
    );
  }
}
