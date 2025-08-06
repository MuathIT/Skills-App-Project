import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/controllers/completed_skills/completed_skills_controller.dart';
import 'package:myskills_app/controllers/profile/profile_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          // show a dialog while loding data.
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileSuccess) {
            // get the user info from the state.
            final user = state.user;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // user avatar.
                          // Container(
                          //   width: 90,
                          //   height: 90,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: Colors.grey,
                          //   ),
                          //   child: ClipRRect(
                          //     borderRadius:BorderRadiusGeometry.circular(20),
                          //     child: Image.asset(
                          //       'assets/images/motivation.jpg',
                          //       height: 90,
                          //       width: 90,
                          //       fit: BoxFit.cover,
                          //     )
                          //   ),
                          // ),

                          // user avatar.
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/images/motivation.jpg'),
                          ),

                          // user name.
                          Text(
                            'Hello ${user['name']}',
                            style: GoogleFonts.bebasNeue(
                              color: Colors.grey[300],
                              fontSize: 28,
                            ),
                          ), 

                          // (more) icon.
                          Icon(
                            Icons.more_horiz,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // motivation box.
                      Container(
                        width: double.infinity,
                        height: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white70,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(20),
                          child: Image.asset(
                            'assets/images/motivation.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),

              // completed skills list.
               Expanded(
                 child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: BlocBuilder<CompletedSkillsCubit, CompletedSkillsState>(
                      builder: (context, state) {
                        if (state is SkillsEmpty){
                          return Center(
                            child: Text(
                              state.emptyMessage,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          );
                        }
                        else if (state is SkillsSuccess) {
                          final skills = state.skills; // user all skills.

                          // completed skills UI.
                          return ListView.separated(
                            itemCount: skills.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              // store the current completed task index.
                              final completedSkill = skills[index];
                                            
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Container(
                                  height: 75,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.brown[300],
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black45,
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          completedSkill['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
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
                        return const SizedBox();
                      },
                    ),
                  ),
               ),
              ],
            );
          }
          // show a failure message if state is failure.
          else if (state is ProfileFailure) {
            return Center(
              child: Text(
                state.failureMessage,
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
