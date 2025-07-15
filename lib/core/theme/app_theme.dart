import 'package:flutter/material.dart';
import 'color_schemes.dart';

import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    appBarTheme: const AppBarTheme(centerTitle: true),
    // textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      titleLarge: const TextStyle(fontWeight: FontWeight.bold),
      bodyMedium: const TextStyle(fontSize: 16),
    ),
  );
}
