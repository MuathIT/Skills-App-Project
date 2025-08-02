


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/core/data/user_helper.dart';

// ---------- Current Skill States ----------

abstract class CurrentSkillState {}

class CurrentSkillInitial extends CurrentSkillState {}

class CurrentSkillLoading extends CurrentSkillState {}

class CurrentSkillSuccess extends CurrentSkillState {
  // git the user current skill from firebase.
  final Map<String, dynamic> currentSkill;
  CurrentSkillSuccess(this.currentSkill);
}
// handels the state when it's empty.
class CurrentSkillEmpty extends CurrentSkillState {
  final String emptyMessage;
  CurrentSkillEmpty(this.emptyMessage);
}

class CurrentSkillFailure extends CurrentSkillState {
  final String failureMessage;
  CurrentSkillFailure(this.failureMessage);
}

// ---------- Current Skill Cubit ----------

class CurrentSkillCubit extends Cubit<CurrentSkillState>{
  CurrentSkillCubit() : super (CurrentSkillInitial());

  // this method will fetch the current skill from firebase.
  Future<void> fetchCurrentSkill () async{
    // emit loading state to the builder.
    emit(CurrentSkillLoading());

    // check if the user not logged in.
    if (UserHelper.uid == null){
      emit(CurrentSkillFailure('User not logged in'));
      return;
    }

    // get into the firebase and git the user current skill.
    try {
      // get the user document.
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(UserHelper.uid).get();
      // get the current skill id from the user doc.
      final currentSkillId = userDoc['currentSkillId'];

      // get the current skill doc by it's id.
      final currentSkillDoc = await FirebaseFirestore.instance.collection('skills').doc(currentSkillId).get();
      // store the currentSkill data and pass it to the success state.
      final currentSkillData = currentSkillDoc.data();

      // check if the field is empty.
      if (currentSkillData == null){ 
        emit(CurrentSkillEmpty("You're not working on a skill yet.")); 
      } 
      // if t's not empty? emit the success state.
      else{
        emit(CurrentSkillSuccess(currentSkillData));
      }
    } catch (e) {
      // emit failure state.
      emit(CurrentSkillFailure("Couldn't get your current skill: $e"));
    }
  }
}