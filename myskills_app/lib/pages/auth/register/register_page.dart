import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/bottomBar/bottom_bar.dart';
import 'package:myskills_app/controllers/auth/auth_controller.dart';
import 'package:myskills_app/controllers/completed_skills/completed_skills_controller.dart';
import 'package:myskills_app/controllers/current_skill/current_skill/current_skill_controller.dart';
import 'package:myskills_app/controllers/home/home_controller.dart';
import 'package:myskills_app/controllers/profile/profile_controller.dart';
import 'package:myskills_app/controllers/tasks/tasks_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/auth/login/login_page.dart';
import 'package:myskills_app/pages/auth/util/textFieldControllers/text_field_controllers.dart';
import 'package:myskills_app/models/userDetails/user.dart';
import 'package:myskills_app/pages/widgets/text_button.dart';
import 'package:myskills_app/util/custom_snack_bar.dart';



class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // first name controller.
  final _nameController = TextEditingController();

  // confirm password controller.
  final _confirmPasswordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    // this function will confirm the password.
    bool confirmPassword (){
      return TextFieldControllers.getPassword().text == _confirmPasswordController.text;
    }
    // this method will send the user details to the register function.
    void register (){
      final cubit = context.read<AuthCubit>();
      // create a user object.
      final user = NewUser(
        name: _nameController.text.trim().toUpperCase(),
        email: TextFieldControllers.getEmail().text.trim(),
        password: TextFieldControllers.getPassword().text.trim()
      );

      if (confirmPassword()){ // check if the passwords are same.
        // send the details to the register function.
        cubit.register(user);
        // clear the controllers.
        _nameController.clear();
        TextFieldControllers.getEmail().clear();
        TextFieldControllers.getPassword().clear();
        _confirmPasswordController.clear();
      }
      // passwords are not identical.
      else {
        showCustomSnackBar(context, 'Passwords should be same', success: false);
      }
    }

    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // tell the user that the app is loading.
          if (state is AuthLoading) {
            showDialog(
              context: context,
              builder: (_) => Center(child: CircularProgressIndicator()),
            );
          } else {
            // when the loading state is over, pop the dialog.
            Navigator.of(context, rootNavigator: true).pop();
          }

          if (state is AuthSuccess) {
            // tell the user that he has successfully registered.
            showCustomSnackBar(context, state.successMessage);

            // fetch the data after sign in.
            context.read<HomeCubit>().fetchUnCompletedSkills();
            context.read<CurrentSkillCubit>().fetchCurrentSkill();
            context.read<TasksCubit>().fetchTasks();
            context.read<ProfileCubit>().userInfo();
            context.read<CompletedSkillsCubit>().fetchCompletedSkills();
            
            // navigate to the home page.
            Navigator.of(
              context,
            ).pushReplacement(MaterialPageRoute(builder: (_) => BottomBar()));
          } else if (state is AuthFailure) {
            // tell the user that he hasn't registered.
            showCustomSnackBar(context, state.failureMessage, success: false);
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                decoration: BoxDecoration(
                  border: BoxBorder.all(
                    style: BorderStyle.solid,
                    color: Colors.white60,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // box title.
                    Text(
                      'Welcome To Tarraqi',
                      style: GoogleFonts.bebasNeue(
                        color: ColorsManager.homeWidgetsColor,
                        fontSize: 36,
                      ),
                    ),

                    // greet the user.
                    Text(
                      "Hello stranger!  Register with your details and let's be friends.",
                      style: GoogleFonts.acme(
                        color: ColorsManager.homeWidgetsColor,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // first name textField.
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: ColorsManager.barColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'First name',
                          labelStyle: TextStyle(
                            color: ColorsManager.homeWidgetsColor,
                          ),
                          hintText: 'Write your first name..',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(color: Colors.grey[400]),
                        cursorColor: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // email textField.
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        color: ColorsManager.barColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: TextFieldControllers.getEmail(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: ColorsManager.homeWidgetsColor,
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: ColorsManager.homeWidgetsColor,
                          ),
                          hintText: 'you@example.com',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(color: Colors.grey[400]),
                        cursorColor: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // password textField.
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        color: ColorsManager.barColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        obscureText: true,
                        controller: TextFieldControllers.getPassword(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.vpn_key_outlined,
                            color: ColorsManager.homeWidgetsColor,
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: ColorsManager.homeWidgetsColor,
                          ),
                          hintText: '********',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(color: Colors.grey[400]),
                        cursorColor: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // confirm password textField.
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        color: ColorsManager.barColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        obscureText: true,
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.password_outlined,
                            color: ColorsManager.homeWidgetsColor,
                          ),
                          labelText: 'Confirm password',
                          labelStyle: TextStyle(
                            color: ColorsManager.homeWidgetsColor,
                          ),
                          hintText: '********',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(color: Colors.grey[400]),
                        cursorColor: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // register button.
                    TextButtonCard(
                      text: 'Register',
                      onPressed: () {
                        register();
                      },
                      backgroundColor: ColorsManager.progressCircleColor,
                    ),

                    const SizedBox(height: 25),

                    // already have account? button.
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        child:RichText(
                      text: TextSpan(
                        style: GoogleFonts.acme(
                          color: ColorsManager.homeWidgetsColor,
                          fontSize: 18
                        ),
                        children: [
                          TextSpan(
                            text: "Already have an account?"
                          ),
                          TextSpan(
                            text: " Login",
                            style: TextStyle(
                              color: Colors.lightBlue
                            )
                          )
                        ]
                      ),

                    ),
                        // navigate to the reset page.
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => LoginPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
