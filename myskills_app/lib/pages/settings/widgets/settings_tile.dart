

import 'package:flutter/material.dart';
import 'package:myskills_app/core/resources/colors.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const SettingsTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        minTileHeight: 25,
        hoverColor: Colors.lightBlue,
        tileColor: ColorsManager.barColor,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: ColorsManager.homeWidgetsColor,
          ),
        ),
      ),
    );
  }
}