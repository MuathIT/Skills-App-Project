


import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static final SharedPreferenceHelper _instance = SharedPreferenceHelper._internal(); // This line put every new object from this class in the same memory place.

  late SharedPreferences _prefs;

  SharedPreferenceHelper._internal();

  factory SharedPreferenceHelper() => _instance; // factory => مصنع , this line makes each object defined from this class takes the _instance place in the memory.

  Future<void> init() async{
    _prefs = await SharedPreferences.getInstance();
  }

  String? getString(String key){ // String? means this function could return string or null.
    return _prefs.getString(key);
  }
  
  Future<void> setString(String key, String value) => _prefs.setString(key, value);

  List<String>? getList(String key){
    return _prefs.getStringList(key);
  }


  Future<void> setList(String key, List<String> value) => _prefs.setStringList(key, value);
  

  Future<void> clear() => _prefs.clear();

}