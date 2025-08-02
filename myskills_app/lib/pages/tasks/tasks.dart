


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myskills_app/core/resources/colors.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: ColorsManager.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'My tasks',
          style: GoogleFonts.mPlus1p(
            color: ColorsManager.homeWidgetsColor,
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}