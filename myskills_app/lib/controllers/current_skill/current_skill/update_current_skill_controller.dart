

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/core/data/user_helper.dart';

// ---------- Update Current Skill States ----------

abstract class UpdateCurrentSkillState {}

class UpdateInitial extends UpdateCurrentSkillState{}

class UpdateLoading extends UpdateCurrentSkillState{}

class UpdateSuccess extends UpdateCurrentSkillState{
  final String successMessage;
  UpdateSuccess(this.successMessage);
}

class UpdateFailure extends UpdateCurrentSkillState{
  final String failureMessage;
  UpdateFailure(this.failureMessage);
}

// ---------- Update Current Skill Cubit ----------

class UpdateCurrentSkillCubit extends Cubit<UpdateCurrentSkillState>{
  UpdateCurrentSkillCubit() : super (UpdateInitial());

  // this method will update the skill.
  Future<void> updateCurrentSkill (String skillId) async{
    emit(UpdateLoading());
    // check if the user id is null.
    if (UserHelper.uid == null){
      emit(UpdateFailure("User not logged in."));
      return;
    }
    try {
        // get into the user document and set the new skill.
        await FirebaseFirestore.instance.collection('users').doc(UserHelper.uid).update(
          {
            'currentSkillId' : skillId
          }
        );
        emit(UpdateSuccess("Current skill has been changed successfully"));
      } catch (e) {
        emit(UpdateFailure("Couldn't change your current skill: $e"));
      }
  }

  // this method will update the level of the skill.
  Future<void> updateSkillLevel (String skillId, String level) async{
    emit(UpdateLoading());

    // get into the skill document and update the level.
    try {
      // go to the skill doc in the db.
      await FirebaseFirestore.instance.collection('skills').doc(skillId).update(
        {
          'level' : level
        }
      );
      emit(UpdateSuccess("Your level has been changed successfully"));
    } catch (e) {
      emit(UpdateFailure("Couldn't change your skill level: $e"));
    }
  }
} 