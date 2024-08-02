import 'package:flutter/material.dart';

final darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.black,
    ),
    fontFamily: 'Involve',
    scaffoldBackgroundColor: Colors.black,
    tabBarTheme: const TabBarTheme(
      labelStyle: TextStyle(fontSize: 16),
      unselectedLabelStyle: TextStyle(fontSize: 16),
      // unselectedLabelColor: ColorRes.grayWhite,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white, width: 1.0),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        decorationColor: Colors.white,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    ));
