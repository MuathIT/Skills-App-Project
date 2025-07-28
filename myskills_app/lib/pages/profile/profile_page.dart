import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/controllers/profile/profile_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';



class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => ProfileCubit()..userInfo(), child: const ProfileScreen());
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.profilePageBacgroundColor,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          // show a dialog while loding data.
          if (state is ProfileLoading){
            return const Center(child: CircularProgressIndicator());
          }
          else if (state is ProfileSuccess){
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
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white70,
                          ),
                          // child: ClipRRect(
                          //   borderRadius:BorderRadiusGeometry.circular(50),
                          //   child: Image.asset('assets/images/avatar.jpg', fit: BoxFit.cover,)
                          // ),
                        ),

                        // user name.
                        Text(
                          'Hello ${user['name']}',
                          style: GoogleFonts.bebasNeue(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                        

                        SizedBox(),
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
                    color: Colors.white70,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: ListView.separated(
                    itemCount: 10,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 75,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.brown[300],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: Colors.black45, blurRadius: 12),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
          }
          // show a failure message if state is failure.
          else if (state is ProfileFailure){
            return Center(
              child: Text(
                state.failureMessage,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
