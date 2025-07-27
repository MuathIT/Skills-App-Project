
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/core/data/shared_preference.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String successMessage;
  LoginSuccess(this.successMessage);
}

class LoginFailure extends LoginState {
  final String failureMessage;
  LoginFailure(this.failureMessage);
}

class LoginCubit extends Cubit<LoginState>{
  LoginCubit() : super (LoginInitial());

  // send the user info to check if he's already registered before.
  Future<void> login (String email, String password) async{
    emit(LoginLoading());

    try {
      // send the user info to the db.
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      // set the current userEmail to be this email.
      await SharedPreferenceHelper().setString('userEmail', email);
      emit(LoginSuccess('Logged in successfully'));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(e.message ?? 'Cannot login. Try again after a few minutes'));
    }
  }
}