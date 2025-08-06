


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/controllers/auth/auth_controller.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/auth/login/login_page.dart';
import 'package:myskills_app/pages/settings/widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: ColorsManager.backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // settings page title.
        centerTitle: false,
        title: Text(
          'Settings',
          style: GoogleFonts.acme(
            color: ColorsManager.homeWidgetsColor,
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Column(
        children: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              // if the auth state is init.
              // navigate to the login page.
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false
              );
            },
            child: Column(
              children: [
                // logout.
                SettingsTile(
                  title: 'Logout',
                  onTap: (){
                    context.read<AuthCubit>().logout();
                  },
                ),
                // delete.
                SettingsTile(
                  title: 'Delete account',
                  onTap: (){
                    context.read<AuthCubit>().deleteUser();
                  }
                )
              ],
            ),
          )
        ],
      )
    );
  }
}