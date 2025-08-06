


// ---------- Tasks State ----------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/core/data/user_helper.dart';

abstract class TasksState {}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksSuccess extends TasksState {
  // get the tasks from the db.
  final List< Map<String,dynamic> > tasks;
  TasksSuccess(this.tasks);
}

class TasksEmpty extends TasksState {
  final String emptyMessage;
  TasksEmpty(this.emptyMessage);
}
class TasksFailure extends TasksState {
  final String failureMessage;
  TasksFailure(this.failureMessage);
}

// ---------- Tasks Cubit ----------

class TasksCubit extends Cubit<TasksState>{
  TasksCubit () : super (TasksInitial());

  // this method will fetch the tasks from firebase.
  Future<void> fetchTasks ({bool showLoading = true}) async{ // show loading parameter for showing loading in UI.
                                                              // bc I don't want to show it while toggling.
    if (showLoading){ // show loading only when showLoading is true.
      emit(TasksLoading());
    }
    try {
      // check if user didn't logged in.
      if (UserHelper.uid == null){
        emit(TasksFailure("User not logged in"));
        return;
      }
      
      // get the user uncompleted tasks.
      final userDoc = await FirebaseFirestore.instance.collection('users')
      .doc(UserHelper.uid)
      .collection('tasks')
      .orderBy('timestamp', descending: true)
      .get();

      final tasks = userDoc.docs.map((doc){
        final data = doc.data();
        data['taskId'] = doc.id; // get the task document id.
        return data;
      }).toList();

      if (tasks.isEmpty){
        emit(TasksEmpty("You don't have any task"));
      }
      else {  
        emit(TasksSuccess(tasks));
      }
    } catch (e) {
      emit(TasksFailure("Couldn't fetch your tasks"));
    }
  }

  // this method will toggle the completed check.
  Future<void> toggleTaskCompleted (String taskId, bool newValue) async{
    // toggle the completed field in the collection.
    try {
      await FirebaseFirestore.instance.collection('users')
      .doc(UserHelper.uid)
      .collection('tasks')
      .doc(taskId)
      .update(
        {
          'isCompleted' : newValue
        }
      );
      // refresh the tasks.
      await fetchTasks(showLoading: false); 
    } catch (e) {
      emit(TasksFailure("Error: $e"));
    }
  }


  // this method will add a new task.
  Future<void> addNewTask (String name) async{
    
    // task name is required.
    if (name.isEmpty){
      emit(TasksFailure("Task name is required"));
      // refresh the tasks.
      await fetchTasks(showLoading: false);
      return;
    }

    // add the new task to the collection.
    try {
      await FirebaseFirestore.instance.collection('users')
      .doc(UserHelper.uid)
      .collection('tasks')
      .add(
        {
          'name' : name,
          'isCompleted' : false,
          'timestamp' : Timestamp.now()
        }
      );

      // refresh the tasks.
      await fetchTasks(showLoading: false);
    } catch (e) {
      emit(TasksFailure("Couldn't add your new task"));
    }
  }

  // this method will remove a task.
  Future<void> removeTask (String taskId) async{

    // remove the task from the collection.
    try {
      await FirebaseFirestore.instance.collection('users')
      .doc(UserHelper.uid)
      .collection('tasks')
      .doc(taskId)
      .delete();

      // refresh the tasks.
      await fetchTasks(showLoading: false);
    } catch (e) {
      emit(TasksFailure("Couldn't remove the task"));
    }
  }

  // clear user tasks method.
  void clear() => emit(TasksInitial());
}