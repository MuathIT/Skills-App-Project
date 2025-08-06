

// ---------- Auth States ----------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/core/data/shared_preference.dart';
import 'package:myskills_app/core/data/user_helper.dart';
import 'package:myskills_app/models/userDetails/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String successMessage;
  AuthSuccess(this.successMessage);
}

class AuthFailure extends AuthState {
  final String failureMessage;
  AuthFailure(this.failureMessage);
}

// ---------- Auth Cubit ----------

class AuthCubit extends Cubit<AuthState>{
  AuthCubit() : super (AuthInitial());

  // store the firebase auth instance.
  final _auth = FirebaseAuth.instance;
  
  // this method will register the user in firebase.
  Future<void> register (NewUser user) async{
    emit(AuthLoading());

    try {
      // create user in the database.
      await _auth.createUserWithEmailAndPassword(email: user.email, password: user.password);
      // add user details.
      await FirebaseFirestore.instance.collection('users').doc(UserHelper.uid).set(
        // we will add the user details as a map.
        {
          'name' : user.name,
          'email' : user.email,
          'currentSkillId' : user.currentSkill,
          'avatar' : user.avatarUrl
        }
      );
      // let the current userEmail in local storage be this email.
      await SharedPreferenceHelper().setString('userEmail', user.email);
      emit(AuthSuccess('You have successfully registered'));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Cannot register you. Try again after a few minutes'));
    }
  }

  // this method will login the user.
  Future<void> login (String email, String password) async{
    emit(AuthLoading());

    try {
      // send the user info to the db.
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      // set the current userEmail to be this email.
      await SharedPreferenceHelper().setString('userEmail', email);
      emit(AuthSuccess('Logged in successfully'));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Cannot login. Try again after a few minutes'));
    }
  }

  // this method for reset password feature.
  Future<void> resetPassword (String email) async{
    emit(AuthLoading());
    try {
      // send email to the user to reset he's password.
      await _auth.sendPasswordResetEmail(email: email.trim());
      // tell the user the proccess successed.
      emit(AuthSuccess("Email has been sent successfully. Check you box.")); 
    }on FirebaseAuthException catch (e) {
      // tell the user the proccess failed.
      emit(AuthFailure(e.message ?? "Error: Cannot send you email to reset your password\nTry again after a few minutes."));
    }
  }

  // this method will logout the user.
  Future<void> logout () async{
    await _auth.signOut();
    // clear the shared prefrence.
    SharedPreferenceHelper().clear();
    emit(AuthInitial()); // reset the auth state.
  }

  // this method will delete the user account.
  Future<void> deleteUser () async{
    // delete the user skills.
    final userSkills = await FirebaseFirestore.instance.collection('skills').where('userId', isEqualTo: UserHelper.uid).get();
    for (var doc in userSkills.docs){ // a loop to delete each skill doc belong to the user.
      await doc.reference.delete();
    }
    // delete the user doc.
    await FirebaseFirestore.instance.collection('users').doc(UserHelper.uid).delete();
    // delete the user auth.
    await FirebaseAuth.instance.currentUser?.delete();
    // clear the shared prefrence.
    SharedPreferenceHelper().clear();
    emit(AuthInitial()); // reset the auth state.
  }
} 