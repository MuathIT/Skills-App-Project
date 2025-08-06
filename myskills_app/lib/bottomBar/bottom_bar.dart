
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:myskills_app/core/resources/colors.dart';
import 'package:myskills_app/pages/home/home_page.dart';
import 'package:myskills_app/pages/profile/profile_page.dart';
import 'package:myskills_app/pages/settings/settings_page.dart';



class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  // this will navigate the app thorugh the pages by the pages index.
  int _selectedIndex = 0;

  // this method will give the ability to nevigate to the page by passing its index when pressing its icon in the bottom bar.
  void _navigate(int index){
    setState(() {
      _selectedIndex = index; // sets the state to nevigate to the pressing icon's page.
    });
  }

  // the inside app pages.
  final List _pages = [

    // Home.
    HomePage(),

    // Profile.
    ProfilePage(),

    // Settings.
    SettingsPage()
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex], // display the selected index page.
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: _selectedIndex == 1? Colors.grey : ColorsManager.backgroundColor,
          index: _selectedIndex, // display the current page.
          onTap: _navigate, // onTap? navigate.
          buttonBackgroundColor: ColorsManager.homeWidgetsColor,
          color: ColorsManager.barColor,
          animationDuration: Duration(milliseconds: 400),
          items: [
            // home.
            Icon(
              Icons.home,
              color: Colors.blueGrey[300],

            ),
        
            // // add skill
            // Icon(
            //   Icons.add,
            // ),
        
            // profile.
            Icon(
              Icons.person,
              color: Colors.blueGrey[300],
            ),
        
            // settings.
            Icon(
                Icons.settings,
                color: Colors.blueGrey[300],
              ),
          ]
        ),
      );
  }
}