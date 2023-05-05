import 'package:flutter/material.dart';

const kPrimaryColor = Color.fromARGB(255, 69, 126, 159);
const kPrimaryLightColor = Color.fromARGB(255, 212, 239, 255);

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme
          ? const Color.fromARGB(255, 0, 16, 52)
          : const Color(0xFFFFFFFF),
      primaryColor: const Color.fromARGB(255, 71, 98, 156),
      colorScheme: ThemeData().colorScheme.copyWith(
            secondary: isDarkTheme
                ? const Color.fromARGB(255, 255, 255, 255)
                : const Color.fromARGB(255, 195, 190, 255),
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          ),
      cardColor: isDarkTheme
          ? const Color.fromARGB(255, 69, 126, 159)
          : const Color.fromARGB(255, 195, 190, 255),
      canvasColor:
          isDarkTheme ? const Color.fromARGB(255, 24, 24, 24) : Colors.grey[50],
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.black),
          prefixIconColor: Colors.black,
          suffixIconColor: Colors.black,
          iconColor: Colors.black),
    );
  }
}
