

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/core/data/shared_preference.dart';
import 'package:myskills_app/models/userDetails/user.dart';

abstract class RegisterState{}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String successMessage;
  RegisterSuccess(this.successMessage);
}

class RegisterFailure extends RegisterState {
  final String failureMessage;
  RegisterFailure(this.failureMessage);
}


class RegisterCubit extends Cubit<RegisterState>{
  RegisterCubit() : super (RegisterInitial());

  // create user in the db.
  Future<void> register (NewUser user) async{
    emit(RegisterLoading());

    try {
      // create user in the database.
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email, password: user.password);
      // the current user id will be the name of the user document.
      final uID = FirebaseAuth.instance.currentUser?.uid;
      // add user details.
      await FirebaseFirestore.instance.collection('users').doc(uID).set(
        // we will add the user details as a map.
        {
          'name' : user.name,
          'email' : user.email,
        }
      );
      // let the current userEmail in local storage be this email.
      await SharedPreferenceHelper().setString('userName', user.email);
      emit(RegisterSuccess('You have successfully registered'));
    } on FirebaseAuthException catch (e) {
      emit(RegisterFailure(e.message ?? 'Cannot register you. Try again after a few minutes'));
    }

  }

}


