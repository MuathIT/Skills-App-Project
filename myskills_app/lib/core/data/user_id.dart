

// this class will help for the user details.
import 'package:firebase_auth/firebase_auth.dart';

class UserHelper{

  // this will store the user id for me to deal with it in the app.
  static String? uid = FirebaseAuth.instance.currentUser?.uid;
  
}