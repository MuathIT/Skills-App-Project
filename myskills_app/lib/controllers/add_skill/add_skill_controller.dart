


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/models/skill/skill_model.dart';

abstract class AddSkillState{}

class AddSkillInitial extends AddSkillState{}

class AddSkillLoading extends AddSkillState{}

class AddSkillSuccess extends AddSkillState{
  // send a success message to user.
  final String successMessage;
  AddSkillSuccess(this.successMessage);
}

class AddSkillFailure extends AddSkillState{
  // send a fail message to user.
  final String failureMessage;
  AddSkillFailure(this.failureMessage);
}

class AddSkillCubit extends Cubit<AddSkillState> {
  AddSkillCubit() : super(AddSkillInitial());

  // this method will add a new skill in the database. (every new skill by deafult will be a junior level.)
  Future<void> addSkill (Skill newSkill) async{
    if (newSkill.name.isEmpty){
      emit(AddSkillFailure('The skill name is required.'));
      return;
    }

    // emit loading state to the builder.
    emit(AddSkillLoading());

    try {
      // get the current user id to store the skill for him.\
      final uID = FirebaseAuth.instance.currentUser?.uid;
      // insert the new akill into the database.
      await FirebaseFirestore.instance.collection('skills').add(
        {
          'name': newSkill.name,
          'level': newSkill.level,
          'imageUrl': newSkill.imageUrl,
          'userId' : uID
        }
      );
      // emit success state to the builder.
      emit(AddSkillSuccess("The new skill has been added to your skills successfully."));

    } catch (e) {
      // emit failure state to the builder.
      emit(AddSkillFailure("Cannot add new skill: $e"));
    }
  }
}