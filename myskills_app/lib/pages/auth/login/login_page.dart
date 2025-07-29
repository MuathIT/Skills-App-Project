

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/bottomBar/bottomBar.dart';
import 'package:myskills_app/controllers/auth/login/login_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/auth/register/register_page.dart';
import 'package:myskills_app/pages/auth/reset_password/reset_password.dart';
import 'package:myskills_app/pages/auth/util/textFieldControllers/text_field_controllers.dart';
import 'package:myskills_app/pages/widgets/text_button.dart';
import 'package:myskills_app/util/custom_snack_bar.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    // this method will send the info to the login methof in the cubit.
    void login (){
      context.read<LoginCubit>().login(
        TextFieldControllers.getEmail().text,
        TextFieldControllers.getPassword().text
      );
    }

    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      body: BlocConsumer<LoginCubit, LoginState>(
      listener:  (context, state) {
        // tell the user that the app is loading.
        if (state is LoginLoading){
          showDialog(
            context: context,
            builder: (_) => Center(child: CircularProgressIndicator())
          );
        }
        else{
          // when the loading state is over, pop the dialog.
          Navigator.of(context, rootNavigator: true).pop();
        }

        if (state is LoginSuccess){
          // tell the user that he has successfully logged in.
          showCustomSnackBar(context, state.successMessage);

          // clear the controllers.
          TextFieldControllers.getEmail().clear();
          TextFieldControllers.getPassword().clear();

          // navigate to the home page.
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => BottomBar())
          );
        }
        else if (state is LoginFailure){
          // tell the user that he hasn't logged in.
          showCustomSnackBar(context, state.failureMessage, success: false);
        }
      },
      builder: (context, state) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Container(
            height: 500,
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
                "Welcome Back",
                style: GoogleFonts.bebasNeue(
                  color: ColorsManager.homeWidgetsColor,
                  fontSize: 36
                ),
              ),

              // greet the user.
              Text(
                  "Hey there!  You have been missed.",
                  style: GoogleFonts.acme(
                    color: ColorsManager.homeWidgetsColor,
                  )
                ),
              
              const SizedBox(height: 25),

              // email textField.
              Container(
                padding: EdgeInsets.only(left:5),
                decoration: BoxDecoration(
                  color: ColorsManager.barColor,
                  borderRadius: BorderRadius.circular(15)
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
                    labelStyle: TextStyle(color: ColorsManager.homeWidgetsColor),
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
                padding: EdgeInsets.only(left:5),
                decoration: BoxDecoration(
                  color: ColorsManager.barColor,
                  borderRadius: BorderRadius.circular(15)
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
                    labelStyle: TextStyle(color: ColorsManager.homeWidgetsColor),
                    hintText: '********',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  style: TextStyle(color: Colors.grey[400]),
                  cursorColor: Colors.grey[600],
                ),
              ), 

              // forgot password button.
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  child: Text(
                    'Forgot password?',
                    style: GoogleFonts.acme(
                      color: Colors.lightBlue,
                      fontSize: 16
                    ),
                  ),
                  // navigate to the reset page.
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ResetPasswordPage())
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              // login button.
              TextButtonCard(
                text: 'Login',
                onPressed: (){
                  login();
                },
                backgroundColor: ColorsManager.progressCircleColor
              ),

              // const SizedBox(height: 25),
              Spacer(),

              // don't have an account? button.
             Align(
               alignment: Alignment.bottomCenter,
               child: TextButton(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.acme(
                          color: ColorsManager.homeWidgetsColor,
                          fontSize: 18
                        ),
                        children: [
                          TextSpan(
                            text: "Don't have an account?"
                          ),
                          TextSpan(
                            text: " Register now",
                            style: TextStyle(
                              color: Colors.lightBlue
                            )
                          )
                        ]
                      ),

                    ),
                    // navigate to the reset page.
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => RegisterPage())
                      );
                    },
                  ),
             ),
            ],
          ),
        )
        )
      );
    },
    )
    );
  }
}
