

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myskills_app/bottomBar/bottomBar.dart';
import 'package:myskills_app/controllers/auth/login/login_controller.dart';
import 'package:myskills_app/controllers/auth/register/register_controller.dart';
import 'package:myskills_app/controllers/auth/reset_password/reset_password_controller.dart';
import 'package:myskills_app/controllers/home/add_skill/add_skill_controller.dart';
import 'package:myskills_app/controllers/current_skill/current_skill/current_skill_controller.dart';
import 'package:myskills_app/controllers/home/home/home_controller.dart';
import 'package:myskills_app/controllers/profile/profile_controller.dart';
import 'package:myskills_app/core/data/shared_preference.dart';
import 'package:myskills_app/core/data/user_id.dart';
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


  runApp( App() );
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => RegisterCubit(),
        ),
        BlocProvider(
          create: (_) => LoginCubit(),
        ),
        BlocProvider(
          create: (_) => ResetPasswordCubit(),
        ),
        BlocProvider(
          create: (_) => HomeCubit()..fetchSkills(),
          lazy: false, // because we want the skills to load in the home page immediately.
        ),
        BlocProvider(
          create: (_) => CurrentSkillCubit()..fetchCurrentSkill(UserHelper.uid!),
          lazy: false, // because we want the user current skill to load in the home page immediately.
        ),
        BlocProvider(
          create: (_) => AddSkillCubit(),
        ),
        BlocProvider(
          create: (_) => ProfileCubit(),
        ),
      ],
      child: SkillTrackerApp(),
    );
  }
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

