

// ---------- Update Current Skill States ----------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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

  Future<void> updateCurrentSkill (String userId, String skillId) async{
    emit(UpdateLoading());

    try {
      // get into the user document and set the new skill.
      await FirebaseFirestore.instance.collection('users').doc(userId).update(
        {
          'currentSkillId' : skillId
        }
      );
      emit(UpdateSuccess("Current skill has been updated successfully."));
    } catch (e) {
      emit(UpdateFailure("Couldn't update your current skill: $e"));
    }
  }
}