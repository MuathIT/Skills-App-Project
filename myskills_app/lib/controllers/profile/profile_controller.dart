

// ---------- Profile states ----------

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/core/data/user_helper.dart';
import 'package:myskills_app/util/pick_image.dart';

abstract class ProfileState{}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Map<String, dynamic> user; // user info will be used from this state.
  ProfileSuccess(this.user);
}

class ProfileFailure extends ProfileState {
  final String failureMessage;
  ProfileFailure(this.failureMessage);
}

// ---------- Profile cubit ----------

class ProfileCubit extends Cubit<ProfileState>{
  ProfileCubit () : super (ProfileInitial());

  // name.
  String? get uName  {
    if (state is ProfileSuccess){
      return (state as ProfileSuccess).user['name'];
    }
    else {
      return null;
    }    
  }
  // current skill id.
  String? get currentSkillId {
    if (state is ProfileSuccess){
      return (state as ProfileSuccess).user['currentSkillId'];
    }
    else {
      return null;
    }
  }

  // this method will fetch the user info.
  Future<void> userInfo () async{
    // emit loading state to the builder.
    emit(ProfileLoading());

    try {
      // check if the user id is null (user didn't logged in.)
      if (UserHelper.uid == null){
        // emit failure state to the builder.
        emit(ProfileFailure('User not logged in'));
        return;
      }

      // if the user has an id? get he's doc data.
      final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserHelper.uid)
        .get();

      // check if the user data not found.
      if (!docSnapshot.exists){
        // emit failure state to the builder.
        emit(ProfileFailure('User data not found'));
        return;
      }

      // store the user data in a variable.
      final userInfo = docSnapshot.data();

      // check if the user has no data.
      if (userInfo == null){
        // emit failure message.
        emit(ProfileFailure('User data not available.'));
      } else{
        // emit a success state to the builder & send the user data to the state.
        emit(ProfileSuccess(userInfo));
      }
    } catch (e) {
      // emit failure state to the builder.
      emit(ProfileFailure("Error: Couldn't fetch the data"));
    }
  }


  // this method will upload the image to the UI.
  Future<void> pickAndUploadImage() async {
    // get the pickedImage data.
    final pickedImage = await pickImage();

    //   // image url.
    // String? uploadedImageUrl;

    // image bytes.
    // Uint8List? imageData;

    if (pickedImage != null) {
      try {
        // read the image bytes.
        final bytes = await pickedImage.readAsBytes();
        // image name.
        final imageName = pickedImage.name;

        // refresh the page and store the image bytes in imageData.
        // imageData = bytes;

        // image path.
        final imagePath = await uploadImageURL(bytes, imageName);

        // refresh the page and display the image.

        // check if the url is empty.
        if (imagePath.isEmpty){
          emit(ProfileFailure("You didn't picked a pic"));
          return;
        }

        // update the user avatar field.
        await FirebaseFirestore.instance.collection('users')
        .doc(UserHelper.uid)
        .update(
          {
            'avatar' : imagePath
          }
        );
        // refresh the profile page.
        await userInfo();

      } catch (e) {
        emit(ProfileFailure("Couldn't change your profile pic: $e"));
      }
    }
  }

  // // this method will change the user avatar. 
  // Future<void> changeAvatar (String imageUrl) async{
    

  //   } catch (e) {

  //   }
  // }


  // clear user profile method.
  void clear() => emit(ProfileInitial());
}