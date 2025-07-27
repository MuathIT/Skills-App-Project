

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myskills_app/bottomBar/bottomBar.dart';
import 'package:myskills_app/core/data/shared_preference.dart';
import 'package:myskills_app/core/secrets/supabase_keys.dart';
import 'package:myskills_app/firebase_options.dart';
import 'package:myskills_app/pages/auth/login/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  // get the flutter widgets.
  WidgetsFlutterBinding.ensureInitialized();

  // initial the data cores.

  // sharedPreference.
  await SharedPreferenceHelper().init();

  // firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  // supabase.
  await Supabase.initialize(
    url: SupabaseKeys.url,
    anonKey: SupabaseKeys.anonKey
  );


  runApp( SkillTrackerApp() );
}


class SkillTrackerApp extends StatelessWidget {
  const SkillTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'ترقّي | Tarraqi',
      
      home: SharedPreferenceHelper().getString('userEmail') == null // save the user time.
      ? LoginPage()
      : BottomBar()
    );
  }
}

