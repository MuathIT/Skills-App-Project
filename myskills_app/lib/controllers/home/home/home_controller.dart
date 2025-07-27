

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState{}

class HomeLoading extends HomeState{}

class HomeSuccess extends HomeState{
  List< Map<String, dynamic> > skills; // take the user skills from fetch data function.
  HomeSuccess(this.skills);
}
class HomeFailure extends HomeState{
  final String failureMessage;
  HomeFailure(this.failureMessage);
}

class HomeCubit extends Cubit<HomeState>{
  HomeCubit() : super (HomeInitial());

  // fetch the database.
  Future<void> fetchSkills () async{ // fetchs the skills from db.
    emit(HomeLoading());

    try{
      // get the current user id to fetch his skills.
      final uID = FirebaseAuth.instance.currentUser?.uid;

      // get the only skills that belong to this uid.
      final snapshot = await FirebaseFirestore.instance.collection('skills').where('userId', isEqualTo: uID).get();

      final skills = snapshot.docs.map((doc){ // get into the snapshot docs.
        final data = doc.data(); // store the doc's data.
        data['sId'] = doc.id; // store the doc id.
        return data; 
      }).toList(); // store them as a lists.

      emit(HomeSuccess(skills));
    } catch (e){
      emit(HomeFailure('Error: $e'));
    }
  }
}
