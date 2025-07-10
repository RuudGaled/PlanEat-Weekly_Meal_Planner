import 'package:flutter/material.dart';
import 'color_schemes.dart';

class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    appBarTheme: const AppBarTheme(centerTitle: true),
    textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
  );
}
