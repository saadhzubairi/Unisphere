import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UnisphereTheme {
  static TextTheme lightTextTheme = TextTheme(
    labelLarge: GoogleFonts.openSans(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
    labelMedium: GoogleFonts.openSans(
        fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
    labelSmall: GoogleFonts.openSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
        letterSpacing: 0),
    bodyLarge: GoogleFonts.openSans(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
    bodyMedium: GoogleFonts.openSans(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
    bodySmall: GoogleFonts.openSans(
        fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
    displayLarge: GoogleFonts.openSans(
        fontSize: 32, fontWeight: FontWeight.w900, color: Colors.grey.shade700),
    displayMedium: GoogleFonts.openSans(
        fontSize: 21, fontWeight: FontWeight.w900, color: Colors.grey.shade700),
    displaySmall: GoogleFonts.openSans(
        fontSize: 16, fontWeight: FontWeight.w900, color: Colors.grey.shade700),
    titleLarge: GoogleFonts.openSans(
        fontSize: 40, fontWeight: FontWeight.w900, color: Colors.black),
  );

  static TextTheme darkTextTheme = TextTheme(
    labelLarge: GoogleFonts.openSans(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade400),
    labelMedium: GoogleFonts.openSans(
        fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade400),
    labelSmall: GoogleFonts.openSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade400,
        letterSpacing: 0),
    bodyLarge: GoogleFonts.openSans(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    bodyMedium: GoogleFonts.openSans(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    bodySmall: GoogleFonts.openSans(
        fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
    displayLarge: GoogleFonts.openSans(
        fontSize: 32, fontWeight: FontWeight.w900, color: Colors.grey.shade200),
    displayMedium: GoogleFonts.openSans(
        fontSize: 21, fontWeight: FontWeight.w900, color: Colors.grey.shade200),
    displaySmall: GoogleFonts.openSans(
        fontSize: 16, fontWeight: FontWeight.w900, color: Colors.grey.shade200),
    titleLarge: GoogleFonts.openSans(
        fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white),
  );

  static ThemeData light() {
    final themeData = ThemeData();
    return themeData.copyWith(
      /* textTheme: lightTextTheme, */
      /* textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.blue.shade900,
          selectionColor: Colors.blue.shade900,
          selectionHandleColor: Colors.blue.shade900,), */
      textTheme: lightTextTheme,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          background: const Color.fromARGB(255, 244, 244, 244),
          onBackground: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          primary: Colors.blue.shade900,
          onPrimary: Colors.white,
          secondary: Colors.yellow.shade800,
          onSecondary: Colors.white,
          surface: Colors.grey.shade400,
          onSurface: Colors.white,
          tertiary: Colors.grey.shade200,
          onTertiary: Colors.grey.shade900,
          scrim: Colors.grey.shade600,
          outlineVariant: Colors.grey.shade400,
          shadow: Colors.white),
      appBarTheme: AppBarTheme(
        titleSpacing: 0.0,
        centerTitle: true,
        elevation: 0.0,
        color: Colors.grey.shade200,
        titleTextStyle: GoogleFonts.lato(color: Colors.black, fontSize: 22),
      ),
      splashColor: Colors.blue.shade900,
    );
  }

  static ThemeData dark() {
    final themeData = ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        textTheme: darkTextTheme,
        appBarTheme: AppBarTheme(
            titleSpacing: 0.0,
            centerTitle: true,
            elevation: 0.0,
            titleTextStyle:
                GoogleFonts.lato(color: Colors.grey.shade200, fontSize: 22)));
    return themeData.copyWith(
      colorScheme: themeData.colorScheme.copyWith(
        background: Color.fromARGB(255, 60, 60, 60),
        onBackground: Color.fromARGB(255, 255, 255, 255),
        primary: Colors.blueAccent,
        secondary: Colors.red,
        error: Colors.red,
        onError: Colors.white,
        surface: Colors.grey.shade700,
        onSurface: Colors.grey.shade200,
        tertiary: Colors.grey.shade800,
        onTertiary: Colors.grey.shade300,
        scrim: Colors.grey.shade400,
        outlineVariant: Colors.grey.shade400,
        shadow: Color.fromARGB(255, 26, 26, 26),
      ),
      appBarTheme: AppBarTheme(
        titleSpacing: 0.0,
        centerTitle: true,
        elevation: 0.0,
        color: Colors.grey.shade900,
        titleTextStyle: themeData.textTheme.displayMedium,
      ),
      splashColor: Colors.blue.shade900,
    );
  }
}
