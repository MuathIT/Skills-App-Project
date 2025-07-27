

// ---------- Profile states ----------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProfileState{}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Map<String, dynamic>? user; // user info will be used from this state.
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
      // get the current user id.
      final uid = FirebaseAuth.instance.currentUser?.uid;
      // get the user info from firebase.
      final user = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      // store the info in a variable.
      final data = user.data();
      // emit success state to the builder and send the data to the state.
      emit(ProfileSuccess(data));
    } catch (e) {
      // emit failure state to the builder.
      emit(ProfileFailure("Error: Couldn't fetch the data"));
    }
  }
}