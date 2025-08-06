


import 'package:firebase_auth/firebase_auth.dart';
import 'package:myskills_app/controllers/profile/profile_controller.dart';

// this class will help for the user details.

class UserHelper{

  // get the user id and email dynmically.
  static String? get uid => FirebaseAuth.instance.currentUser?.uid;
  static String? get uEmail => FirebaseAuth.instance.currentUser?.email;

  // this method will get the user current skill id.
  static String? getCurrentSkillId (ProfileState state){ // here we pass the state as an argument.
    if (state is ProfileSuccess){  // if the state is success state return the current skill id.
      return state.user['currentSkillId'] as String?; // String? to handle the null.
    }
    else {
      return null;
    }
  }

  // this method will get the user name.
  static String? getUserName (ProfileState state){
    if (state is ProfileSuccess){
      return state.user['name'] as String?;
    }
    else {
      return null;
    }
  }
}

