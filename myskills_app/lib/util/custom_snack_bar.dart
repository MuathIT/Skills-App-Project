




import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// a good shaped snackBar.

void showCustomSnackBar (BuildContext context, String message, {bool success = true}){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: success ? Colors.green[600] : Colors.red[600],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Row(
        children: [
          Icon(
            success ? Icons.check_circle_outline_rounded : Icons.error_outline,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.adamina(color: Colors.white),
            )
          )
        ],
      ),
      duration: Duration(milliseconds: 800),
    )
  );
}