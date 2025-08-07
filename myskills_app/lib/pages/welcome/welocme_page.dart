import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/auth/login/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // app name.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo2.png'),
                        fit: BoxFit.cover
                      )
                    ),
                  ),

                  Text(
                    ' Skillsy',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 64,
                      color: ColorsManager.homeWidgetsColor.withOpacity(0.7),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // fagline.
              Text(
                '“Helps you track and grow your skills”',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey[300],
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 40),

              // features list.
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _featureItem('✅ Set personal goals'),
                  _featureItem('📊 Track your daily progress'),
                  _featureItem('🚀 Stay motivated with real achievements'),
                  _featureItem('🧠 Discover and master new skills'),
                ],
              ),

              const SizedBox(height: 40),

              // motivation message
              Text(
                '🔓 Unlock your potential\n💪 Build your future\n🌱 Grow every day — one skill at a time.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey[300],
                ),
              ),

              const SizedBox(height: 40),

              // get started button.
              ElevatedButton(
                onPressed: () {
                  // navigate to sign in.
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.homeWidgetsColor.withOpacity(0.7),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Let\'s Get Started 🚀',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // a widget that return a decoration of text.
  Widget _featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
