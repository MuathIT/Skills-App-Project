

// ---------- Profile states ----------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProfileState{}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Map<String, dynamic> user; // user info will be used from this state.
  ProfileSuccess(this.user);
}

class ProfileFailure extends ProfileState {
  final String failureMessage;
  ProfileFailure(this.failureMessage);
}

// ---------- Profile cubit ----------

class ProfileCubit extends Cubit<ProfileState>{
  ProfileCubit () : super (ProfileInitial());

  // this method will fetch the user info.
  Future<void> userInfo () async{
    // emit loading state to the builder.
    emit(ProfileLoading());

    try {
      // get the user id.
      final uID = FirebaseAuth.instance.currentUser?.uid;
      // check if the user id is null (user didn't logged in.)
      if (uID == null){
        // emit failure state to the builder.
        emit(ProfileFailure('User not logged in'));
        return;
      }

      // if the user has an id? get he's doc data.
      final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uID)
        .get();

      // check if the user data not found.
      if (!docSnapshot.exists){
        // emit failure state to the builder.
        emit(ProfileFailure('User data not found'));
        return;
      }

      // store the user data in a variable.
      final userInfo = docSnapshot.data();

      // check if the user has no data.
      if (userInfo == null){
        // emit failure message.
        emit(ProfileFailure('User data not available.'));
      } else{
        // emit a success state to the builder & send the user data to the state.
        emit(ProfileSuccess(userInfo));
      }

    } catch (e) {
      // emit failure state to the builder.
      emit(ProfileFailure("Error: Couldn't fetch the data"));
    }
  }
}