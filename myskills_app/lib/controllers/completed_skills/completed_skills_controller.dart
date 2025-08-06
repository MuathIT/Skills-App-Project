



// ---------- Completed skills Cubit ----------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/core/data/user_helper.dart';

abstract class CompletedSkillsState {}

class SkillsInitial extends CompletedSkillsState {}

class SkillsLoading extends CompletedSkillsState {}

class SkillsSuccess extends CompletedSkillsState {
  final List< Map<String, dynamic> > skills; // get the completed skills.
  SkillsSuccess(this.skills);
}

class SkillsEmpty extends CompletedSkillsState {
  final String emptyMessage;
  SkillsEmpty(this.emptyMessage);
}

class SkillsFailure extends CompletedSkillsState {
  final String failureMessage;
  SkillsFailure(this.failureMessage);
}


// ---------- Completed skills Cubit ----------

class CompletedSkillsCubit extends Cubit<CompletedSkillsState>{
  CompletedSkillsCubit () : super (SkillsInitial());

  // this method will fetch the completed skills.
  Future<void> fetchCompletedSkills () async{
    // check user auth.
    if (UserHelper.uid == null){
      emit(SkillsFailure('User not logged in'));
      return;
    }

    try {
      // get the user completed skills.
      final snapsohot = await FirebaseFirestore.instance.collection('skills')
      .where('userId', isEqualTo: UserHelper.uid)
      .where('isCompleted', isEqualTo: true)
      .orderBy('timestamp', descending: true)
      .get();

      // make a list of the completed skills.
      final completedSkills = snapsohot.docs.map((doc){
        // store each doc data.
        final data = doc.data();
        data['skillId'] = doc.id;
        return data;
      }).toList();
      
      // handel the empty list
      if (completedSkills.isEmpty){
        emit(SkillsEmpty("You didn't complete any skill yet"));
      }
      else{
        emit(SkillsSuccess(completedSkills));
      }
    } catch (e) {
      emit(SkillsFailure("Couldn't get your completed skills: $e"));
    }
  }

  // clear user completed skills method.
  void clear() => emit(SkillsInitial());
}

