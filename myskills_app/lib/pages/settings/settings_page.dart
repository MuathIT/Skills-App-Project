


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/core/data/shared_preference.dart';
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
          SettingsTile(
            title: 'Logout',
            onTap: () {
              // clear the user data from the current local storage.
              SharedPreferenceHelper().clear();
              // navigate to the login page.
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginPage()),
                (_) => true
              );
            },
          )
        ],
      )
    );
  }
}