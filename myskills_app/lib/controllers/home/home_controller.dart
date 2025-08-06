

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/core/data/user_helper.dart';
import 'package:myskills_app/models/skill/skill_model.dart';


// ---------- Home States ----------

abstract class HomeState {}

class HomeInitial extends HomeState{}

class HomeLoading extends HomeState{}

class HomeSuccess extends HomeState{
  List< Map<String, dynamic> > skills; // take the user skills from fetch data function.
  HomeSuccess(this.skills);
}

class HomeEmpty extends HomeState{
  final String emptyMessage;
  HomeEmpty(this.emptyMessage);
}

class HomeFailure extends HomeState{
  final String failureMessage;
  HomeFailure(this.failureMessage);
}

// ---------- Home Cubit ----------

class HomeCubit extends Cubit<HomeState>{
  HomeCubit() : super (HomeInitial());

  // fetch the uncompleted skills.
  Future<void> fetchUnCompletedSkills ({bool showLoading = true}) async{ // fetchs the skills from db.
    // handle the loading state for the big fixes.
    if (showLoading){
      emit(HomeLoading());
    }
    if (UserHelper.uid == null){
      emit(HomeFailure("User not logged in"));
      return;
    } 
    
    try{

      // get the only skills that belong to this uid.
      final snapshot = await FirebaseFirestore.instance.collection('skills')
      .where('userId', isEqualTo: UserHelper.uid)
      .where('isCompleted', isEqualTo: false)
      .orderBy('timestamp', descending: true)
      .get();

      final skills = snapshot.docs.map((doc){ // get into the snapshot docs.
        final data = doc.data(); // store the doc's data.
        data['skillId'] = doc.id; // store the doc id.
        return data; 
      }).toList(); // store them as a lists.

      if (skills.isEmpty){ // check if the user has no uncompleted skills.
        // emit empty state.
        emit(HomeEmpty("You don't have skills yet."));
      }
      else {
        emit(HomeSuccess(skills));
      }
    } catch (e){
      emit(HomeFailure('Error: $e'));
    }
  }

  // this method will add a new skill in the db. 
  Future<void> addSkill (Skill newSkill) async{
    // skill's name is required.
    if (newSkill.name.isEmpty){
      emit(HomeFailure("Skill's name is required"));
      // refresh the uncompleted skills.
      await fetchUnCompletedSkills(showLoading: false); 
      return;
    }
    try {
      // insert the new akill into the database.
      await FirebaseFirestore.instance.collection('skills').add(
        {
          'name': newSkill.name,
          'level': newSkill.level,
          'isCompleted' : newSkill.isCompleted,
          'imageUrl': newSkill.imageUrl,
          'userId' : UserHelper.uid,
          'timestamp' : Timestamp.now()
        }
      );
      // refresh the uncompleted skills.
      await fetchUnCompletedSkills(showLoading: false);
    } catch (e) {
      // emit failure state to the builder.
      emit(HomeFailure("Cannot add new skill: $e"));
    }
  }

  // this method will delete the given skill from the db.
  Future<void> deleteSkill (String skillId) async{
    try {
      // get into the skill id and delete it from firebase.
      await FirebaseFirestore.instance.collection('skills').doc(skillId).delete();
      // refresh the uncompleted skills.
      await fetchUnCompletedSkills(showLoading: false);
    } catch (e) {
      emit(HomeFailure("Couldn't delete the skill: $e"));
    }
  }

  // this method will update the level of the skill.
  Future<void> updateSkillLevel (String skillId, String level) async{

    // get into the skill document and update the level.
    try {
      // go to the skill doc in the db.
      await FirebaseFirestore.instance.collection('skills').doc(skillId).update(
        {
          'level' : level
        }
      );
      // refresh the uncompleted skills.
      await fetchUnCompletedSkills(showLoading: false);
    } catch (e) {
      emit(HomeFailure("Couldn't change your skill level: $e"));
    }
  }

  // this method will mark the skill as completed.
  Future<void> markSkillAsCompleted (String skillId) async{
    try {
      // mark the skill as completed.
      await FirebaseFirestore.instance.collection('skills').doc(skillId).update(
        {
          'isCompleted' : true
        }
      );
      // clear the user current skill.
      await FirebaseFirestore.instance.collection('users').doc(UserHelper.uid).update(
        {
          'currentSkillId' : null
        }
      );
      // refresh the completed skills.
      await fetchUnCompletedSkills(showLoading: false);
    } catch (e) {
      emit(HomeFailure("Couldn't mark the skill as completed"));
    }
  }

  // clear user home method.
  void clear() => emit(HomeInitial());
  
}
