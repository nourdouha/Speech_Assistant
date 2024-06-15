import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Color.fromARGB(255, 18, 74, 78),
        onSecondary: Colors.white));

final darkTheme = ThemeData(
    colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: Colors.blueGrey,
        onPrimary: Colors.white,
        secondary: Color.fromARGB(255, 69, 158, 151),
        onSecondary: Colors.white));
