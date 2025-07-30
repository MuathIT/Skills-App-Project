import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/controllers/current_skill/current_skill/current_skill_controller.dart';
import 'package:myskills_app/controllers/home/home_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/home/widgets/motivation_card.dart';
import 'package:myskills_app/pages/home/widgets/skill_card.dart';
import 'package:myskills_app/pages/home/widgets/skill_progress_card.dart';
import 'package:myskills_app/pages/new_skill/add_skill_dialog.dart';
import 'package:myskills_app/pages/skills/skills_page.dart';
import 'package:myskills_app/util/delete_confirmation_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // store the home cubit in a variable, we will gonna use it often.
    final cubit = context.read<HomeCubit>();
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
            showDialog(context: context, builder: (_) => AddSkillDialog()).then(
              (_) {
                // fetch the data again in the home page when the dialog closed.
                cubit.fetchSkills();
              },
            );
          },
          child: Icon(Icons.add, color: Colors.black),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          // show a dialog when loading data.
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // empty home.
          else if (state is HomeEmpty) {
            return Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24
                  ),
                  children: [
                    TextSpan(
                      text: state.emptyMessage
                    ),
                    TextSpan(
                      text: "\nAdd a new skill to get started :)",
                      style: TextStyle(color: ColorsManager.homeWidgetsColor, fontWeight: FontWeight.bold)
                    )
                  ]
                ),
              
              ),
            );
          }
          // success home.
          else if (state is HomeSuccess) {
            // get the user skills from database.
            final skills = state.skills;

            // home page.
            return Padding(
              padding: const EdgeInsets.only(top: 60, right: 15, left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Motivation.
                  MotivationCard(),

                  Spacer(),
                  // const SizedBox(height: 40),

                  // Current Skill Progress
                  Column(
                    children: [
                      Text(
                        'My Current skill'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 20,
                            color: ColorsManager.homeWidgetsColor,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                      const SizedBox(height: 15),

                      SkillProgressCard(
                        child: BlocBuilder<CurrentSkillCubit, CurrentSkillState>(
                          builder: (context, state) {
                            // show a dialog when loading the skill.
                            if (state is CurrentSkillLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                      
                            // display the emptiness message when the state is empty.
                            else if (state is CurrentSkillEmpty){
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    state.emptyMessage,
                                    style: GoogleFonts.acme(
                                      color: ColorsManager.homeWidgetsColor,
                                      fontSize: 18
                                    ),
                                  ),
                                ),
                              );
                            }
                      
                            // show the skill when it's loaded successfully.
                            else if (state is CurrentSkillSuccess) {
                              // store the current skill.
                              final currentSkill = state.currentSkill;
                              return Column(
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
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                      ),
                    ],
                  ),

                  Spacer(),

                  // const SizedBox(height: 20),
                  Row(
                    children: [
                      // Current skill details.
                      Column(
                        children: [
                          Text(
                            'My Tasks'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              color: ColorsManager.homeWidgetsColor,
                              fontWeight: FontWeight.bold
                            ),
                          ),

                          const SizedBox(height: 10),

                          SkillCard(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // skill name.
                                Text(
                                  'Empty',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Spacer(),

                      // User other skills.
                      Column(
                        children: [
                          Text(
                            'My Skills'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              color: ColorsManager.homeWidgetsColor,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow()
                              ]
                            ),
                          ),

                          const SizedBox(height: 10),

                          GestureDetector(
                            // onTap? navigate to the skills page.
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SkillsPage(),
                                ),
                              );
                            },
                            child: SkillCard(
                              child: ListView.separated(
                                itemCount: skills.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 5),
                                itemBuilder: (_, index) {
                                  // store the skill of the current index.
                                  final skill = skills[index];
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

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
                                        onPressed: (){
                                          showDialog(
                                            context: context,
                                            builder: (_) => DeleteConfirmationDialog(skillId: skill['skillId']));
                                        },
                                        icon: const Icon(
                                          Icons.delete
                                        )
                                      )
                                      
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Spacer(),
                ],
              ),
            );
          }
          // home failure.
          else if (state is HomeFailure) {
            return Center(
              child: Text(
                state.failureMessage,
                style: TextStyle(color: Colors.red, fontSize: 24),
              ),
            );
          }

          // home initial.
          return const Center(child: Text("Error: Couldn't fetch the data."));
        },
      ),
    );
  }
}
