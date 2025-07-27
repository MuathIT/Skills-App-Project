
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/controllers/home/home/home_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/home/widgets/motivation_card.dart';
import 'package:myskills_app/pages/home/widgets/skill_card.dart';
import 'package:myskills_app/pages/home/widgets/skill_progress_card.dart';
import 'package:myskills_app/util/add_skill_dialog.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // provide the cubit to the page.
    return BlocProvider(create: (_) => HomeCubit()..fetchSkills(), child: HomeScreen());
  }
}


// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // // list to hold the user skills.
  // final List<Skill> _skills = Skill.getSkills();

  // // this to get the current skill.
  // Skill currentSkill = Skill.currentSkill;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,

      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {

          // show a dialog when loading data.
          if (state is HomeLoading){
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeSuccess){
            // get the user skills from database.
            final skills = state.skills;
            // let the first skill by default be the current skill.
            final currentSkill = skills[0];

            return Padding(
            padding: const EdgeInsets.only(top: 60, right: 15, left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Motivation.
                MotivationCard(),
            
                Spacer(),
                // const SizedBox(height: 40),
            
                // Skill Progress
                SkillProgressCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // current skill name.
                      Text(
                        currentSkill['name'],
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
                  ),
                ),
            
                Spacer(),
            
                // const SizedBox(height: 20),
                Row(
                  children: [
                    // Current skill details.
                    SkillCard(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white70,
                              ColorsManager.homeWidgetsColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // skill name.
                            Text(
                              currentSkill['name'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // skill level.
                            Text(
                              currentSkill['level'],
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            
                    Spacer(),
            
                    // User other skills.
                    SkillCard(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ListView.separated(
                          itemCount: skills.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 5),
                          itemBuilder: (_, index) {
                            // stores the skill of the current index in the list.
                            final skill = skills[index];
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white70,
                                    ColorsManager.homeWidgetsColor,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amberAccent.shade100,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  // IconButton(
                                  //   onPressed: (){},
                                  //   icon: const Icon(
                                  //     Icons.delete,
                                  //   )
                                  // ),
                                    
                                  // skill level.
                                  Text(
                                    skill['level'],
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
            
                const SizedBox(height: 40),

                // add new skill button.
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: ColorsManager.homeWidgetsColor,
                    hoverColor: Colors.grey[400],
                    onPressed: () {
                      // store the cubit to use it easly.
                      final cubit = context.read<HomeCubit>();
                      // show the add skill card dialog.
                      showDialog(
                        context: context,
                        builder: (_) => AddSKillPage(),
                        
                      ).then((_){ // fetch the data again in the home page when the dialog closed.
                        cubit.fetchSkills();
                      });
                    },
                    child: Icon(Icons.add, color: Colors.black),
                   ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text("Error: Couldn't fetch the data."));
        },
      ),
    );
  }
}
