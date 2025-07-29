


// ---------- Current Skill States ----------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CurrentSkillState {}

class CurrentSkillInitial extends CurrentSkillState {}

class CurrentSkillLoading extends CurrentSkillState {}

class CurrentSkillSuccess extends CurrentSkillState {
  // git the user current skill from firebase.
  final Map<String, dynamic> currentSkill;
  CurrentSkillSuccess(this.currentSkill);
}

class CurrentSkillFailure extends CurrentSkillState {
  final String failureMessage;
  CurrentSkillFailure(this.failureMessage);
}

// ---------- Current Skill Cubit ----------
class CurrentSkillCubit extends Cubit<CurrentSkillState>{
  CurrentSkillCubit() : super (CurrentSkillInitial());

  // this method will fetch the current skill from firebase.
  Future<void> fetchCurrentSkill (String userId) async{
    // emit loading state to the builder.
    emit(CurrentSkillLoading());

    // get into the firebase and try to git the user current skill.
    try {
      // get the user document.
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      // get the current skill id from the user doc.
      final currentSkillId = userDoc['currentSkillId'];

      // get the current skill doc by it's id.
      final currentSkillDoc = await FirebaseFirestore.instance.collection('skills').doc(currentSkillId).get();
      // store the currentSkill data and pass it to the success state.
      final currentSkillData = currentSkillDoc.data();

      // emit success state.
      emit(CurrentSkillSuccess(currentSkillData!)); // ! means not null
    } catch (e) {
      // emit failure state.
      emit(CurrentSkillFailure("Couldn't get your current skill: $e"));
    }
  }
}