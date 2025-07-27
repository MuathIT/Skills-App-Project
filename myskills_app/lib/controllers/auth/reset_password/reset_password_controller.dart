


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// ------------ Reset password states ------------
abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String successMessage;
  ResetPasswordSuccess(this.successMessage);
}

class ResetPasswordFailure extends ResetPasswordState {
  final String failureMessage;
  ResetPasswordFailure(this.failureMessage);
}


// ------------ Reset password cubit ------------
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super (ResetPasswordInitial());

  Future<void> resetPassword (String email) async{
    // let the user in hold.
    emit(ResetPasswordLoading());

    try {
      // send email to the user to reset he's password.
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      // tell the user the proccess successed.
      emit(ResetPasswordSuccess("Email has been sent successfully. Check you box.")); 
    }on FirebaseAuthException catch (e) {
      // tell the user the proccess failed.
      emit(ResetPasswordFailure(e.message ?? "Error: Cannot send you email to reset your password\nTry again after a few minutes."));
    }

  }
}