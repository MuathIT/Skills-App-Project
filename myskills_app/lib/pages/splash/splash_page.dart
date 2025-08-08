import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/bottomBar/bottom_bar.dart';
import 'package:myskills_app/core/data/shared_preference.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/welcome/welocme_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SharedPreferenceHelper().getString('userEmail') == null ? const WelcomePage() : const BottomBar() // save the user login.
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo2.png'), // your app logo
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // app name
            Text(
              "Skillsy",
              style: GoogleFonts.bebasNeue(
                fontSize: 40,
                color: ColorsManager.homeWidgetsColor,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 10),

            // Tagline
            Text(
              "Track & grow your skills!",
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 50),

            // Loading spinner
            const CircularProgressIndicator(
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
