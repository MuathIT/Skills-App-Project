


import 'package:firebase_auth/firebase_auth.dart';

// this class will help for the user details.

class UserHelper{

  // get the user id and email dynmically.
  static String? get uid => FirebaseAuth.instance.currentUser?.uid;
  static String? get uEmail => FirebaseAuth.instance.currentUser?.email;

}

