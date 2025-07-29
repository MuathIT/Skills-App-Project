import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/controllers/auth/reset_password/reset_password_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/auth/util/textFieldControllers/text_field_controllers.dart';
import 'package:myskills_app/util/custom_snack_bar.dart';


class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    // this method will send the email to the cubit.
    void resetPassword() {
      context.read<ResetPasswordCubit>().resetPassword(
        TextFieldControllers.getEmail().text,
      );
    }

    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      // for the return arrow.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordLoading){
            showDialog(
              context: context,
              builder: (_) => Center(child: const CircularProgressIndicator())
            );
          }
          else {
            // when the loading state finish, get back to the page.
            Navigator.of(context, rootNavigator: true).pop();
          }

          if (state is ResetPasswordSuccess){
            // tell the user that you sent the email.
            showCustomSnackBar(context, state.successMessage);
            // clear the controllers.
            TextFieldControllers.getEmail().clear();
            // get back to the login page.
            Navigator.of(context).pop();
          }

          else if (state is ResetPasswordFailure){
            // tell the user that an error occurred.
            showCustomSnackBar(context, state.failureMessage, success: false);
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),

              // form shape.
              child: Container(
                height: 250,
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
                      "Reset your password",
                      style: GoogleFonts.bebasNeue(
                        color: ColorsManager.homeWidgetsColor,
                        fontSize: 36,
                      ),
                    ),

                    // greet the user.
                    Text(
                      "Hey there! Don't worry just write your email here and reset your password.",
                      style: GoogleFonts.acme(
                        color: ColorsManager.homeWidgetsColor,
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
                          suffixIcon: IconButton(
                            onPressed: () {
                              resetPassword();
                            },
                            icon: const Icon(
                              Icons.send_outlined,
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                        style: TextStyle(color: Colors.grey[400]),
                        cursorColor: Colors.grey[600],
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
