

// ---------- Delete Skill States ----------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeleteSkillState {}

class DeleteInitial extends DeleteSkillState {}

class DeleteLoading extends DeleteSkillState {}

class DeleteSuccess extends DeleteSkillState {
  final String successMessage;
  DeleteSuccess(this.successMessage);
}

class DeleteFailure extends DeleteSkillState {
  final String failureMessage;
  DeleteFailure(this.failureMessage);
}

// ---------- Delete Skill Cubit ----------

class DeleteSkillCubit extends Cubit<DeleteSkillState>{
  DeleteSkillCubit() : super (DeleteInitial());

  // this method will delete the given skill.
  Future<void> deleteSkill (String skillId) async{
    emit(DeleteLoading());

    try {
      // get into the skill id and delete it from firebase.
      await FirebaseFirestore.instance.collection('skills').doc(skillId).delete();
      emit(DeleteSuccess("The skill has been deleted successfully."));
    } catch (e) {
      emit(DeleteFailure("Couldn't delete the skill: $e"));
    }
  }
}