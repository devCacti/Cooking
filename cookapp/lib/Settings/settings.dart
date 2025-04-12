import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

//? Global Variables
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

class Settings {
  //? Variables
  bool darkMode = true;
  ////bool notifications = true; //? Not used yet

  //* Default values
  Settings({bool? darkMode}) {
    darkMode = darkMode ?? true; // Default value for dark mode
    ////notifications = true; //? Not used yet
  }

  factory Settings.defaultS() {
    return Settings();
  }

  //* Get the dark mode setting from a user settings file called settings.json
  //! If it returns null it means there was an error
  Future<bool?> getDarkMode() async {
    //? Get the path to the application documents directory
    String filePath = await getApplicationDocumentsDirectory()
        .then((value) => "${value.path}/settings.json");

    //? Create a file object with the path
    File file = File(filePath);

    try {
      //? Check if the file exists
      if (await file.exists()) {
        String contents = await file.readAsString();

        // Parse the JSON string to get the dark mode value
        Map<String, dynamic> json = jsonDecode(contents);

        darkMode = json['darkMode'] ?? true; // Default to true if not found
        return darkMode;
      } else {
        // If the file does not exist, create it with the default value
        Map<String, dynamic> json = {'darkMode': darkMode};
        // Write the JSON string to the file
        await file.writeAsString(jsonEncode(json));
        return darkMode;
      }
    } catch (e) {
      // Handle any errors that occur during file operations
      ////print("Error reading settings file: $e");
      return null;
    }
  }

  //* Set the dark mode setting in the user settings file called settings.json
  //! If it returns null it means there was an error
  Future<bool?> setDarkMode(bool value) async {
    //? Get the path to the application documents directory
    String filePath = await getApplicationDocumentsDirectory()
        .then((value) => "${value.path}/settings.json");

    //? Create a file object with the path
    File file = File(filePath);

    //? Tries to write to the file, if it can't do it, catch the exception
    try {
      String contents = await file.readAsString();

      // Parse the JSON string to get the dark mode value
      Map<String, dynamic> json = jsonDecode(contents);

      // Update the dark mode value
      json['darkMode'] = value;

      // Write the updated JSON string to the file
      await file.writeAsString(jsonEncode(json));

      return value;
    } catch (e) {
      // Handle any errors that occur during file operations
      ////print("Error writing settings file: $e");
      return null;
    }
  }
}
