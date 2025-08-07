


import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// this function will let the user to pick an image from gallery.

Future <XFile?> pickImage () async{

  try {
    // get the image.
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 20, // For light memory space.
    );

    // check if the user didn't picked an image.
    if (pickedImage == null){
      return null;
    }
    // if it's not null, return the image data.
    return pickedImage;
  } catch (e) {
    return null;
  }
}

// this function to upload the picked image URL from supabase.
Future<String> uploadImageURL(Uint8List data, String fileName) async{

  // an instance of the supabase DB.
  final supabase = Supabase.instance.client;

  // upload the image's binary file.
  await supabase.storage.from('images')
    .uploadBinary(
      fileName, 
      data,
      fileOptions: const FileOptions(
        upsert: true // to let the user able to upload the same image more than once.
      )
    );
  // get the image url.
  final url = supabase.storage
    .from('images')
    .getPublicUrl(fileName);
  
  return url;
}
