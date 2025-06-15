import 'package:cookapp/Classes/language.dart';
import 'package:cookapp/Classes/snackbars.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

//? Global Variables
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

class Settings {
  //? Variables
  bool darkMode = true;

  static Future<File> get _localSettingsFile async {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    final file = File('${directory.path}/settings.json');
    return file;
  }
  ////bool notifications = true; //? Not used yet

  //* Default values
  Settings({bool? darkMode}) {
    darkMode = darkMode ?? true; // Default value for dark mode
    ////notifications = true; //? Not used yet
  }

  factory Settings.defaultS() {
    return Settings();
  }

  static Future<void> wipeData(BuildContext context) async {
    //? Get the path to the application documents directory
    //? Tries to delete the file, if it can't do it, catch the exception
    File file = await _localSettingsFile;
    try {
      if (await file.exists()) {
        await file.delete();
        showSnackbar(
          // ignore: use_build_context_synchronously
          context,
          "Settings wiped.",
          type: SnackBarType.success,
          isBold: true,
        );
        return;
      }
      showSnackbar(
        // ignore: use_build_context_synchronously
        context,
        "Settings file does not exist.",
        type: SnackBarType.info,
        isBold: true,
      );
    } catch (e) {
      showSnackbar(
        // ignore: use_build_context_synchronously
        context,
        "Error wiping settings file: $e",
        type: SnackBarType.error,
        isBold: true,
      );
      // Handle any errors that occur during file operations
      ////developer.log("Error deleting settings file: $e");
    }
  }

  //* Get the dark mode setting from a user settings file called settings.json
  //! If it returns null it means there was an error
  static Future<bool> getDarkMode(BuildContext context) async {
    bool darkMode = false; // Default value for dark mode

    //? Create a file object with the path
    File file = await _localSettingsFile;

    try {
      //? Check if the file exists
      if (await file.exists()) {
        String contents = file.readAsStringSync();

        // Parse the JSON string to get the dark mode value
        Map<String, dynamic> json = jsonDecode(contents);

        darkMode = json['darkMode'] ?? false; // Default to true if not found

        //showSnackbar(
        //  // ignore: use_build_context_synchronously
        //  context,
        //  "Dark mode setting retrieved: $darkMode",
        //  type: SnackBarType.success,
        //  isBold: true,
        //);
        return darkMode;
      } else {
        file.createSync(); // Create the file if it doesn't exist
        // If the file does not exist, create it with the default value
        Map<String, dynamic> json = {'darkMode': darkMode};
        // Write the JSON string to the file
        file.writeAsStringSync(jsonEncode(json));
        //showSnackbar(
        //  // ignore: use_build_context_synchronously
        //  context,
        //  "Dark mode setting file created with default value $darkMode",
        //  type: SnackBarType.info,
        //  isBold: true,
        //);
        return darkMode;
      }
    } catch (e) {
      // Handle any errors that occur during file operations
      ////developer.log("Error reading settings file: $e");
      showSnackbar(
        // ignore: use_build_context_synchronously
        context,
        "Error getting dark mode setting: $e",
        type: SnackBarType.error,
        isBold: true,
      );
      return false;
    }
  }

  //* Set the dark mode setting in the user settings file called settings.json
  //! If it returns null it means there was an error
  static Future<bool?> setDarkMode(bool value) async {
    //? Get the path to the application documents directory
    File file = await _localSettingsFile;

    //? Tries to write to the file, if it can't do it, catch the exception
    try {
      if (!await file.exists()) {
        // If the file does not exist, create it with the default value
        Map<String, dynamic> json = {'darkMode': value};
        await file.writeAsString(jsonEncode(json));
        return value; // Return the value if the file was created successfully
      }

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
      ////developer.log("Error writing settings file: $e");
      return null;
    }
  }

  //* Get the language setting from a user settings file called settings.json
  static Future<String> getLanguage(BuildContext context) async {
    //? Get the path to the application documents directory
    String filePath = await _localSettingsFile.then((file) => file.path);

    //? Create a file object with the path
    File file = File(filePath);

    try {
      //? Check if the file exists
      if (await file.exists()) {
        String contents = await file.readAsString();

        // Parse the JSON string to get the language value
        Map<String, dynamic> json = jsonDecode(contents);

        //showSnackbar(
        //  // ignore: use_build_context_synchronously
        //  context,
        //  "Language setting retrieved: ${json['language'] ?? 'en'}",
        //  type: SnackBarType.success,
        //  isBold: true,
        //);

        return json['language'] ?? 'en'; // Default to 'en' if not found
      } else {
        // ignore: use_build_context_synchronously
        await setLanguage(LanguageType.en, context);

        //showSnackbar(
        //  // ignore: use_build_context_synchronously
        //  context,
        //  "Language setting file created with default value 'en'",
        //  type: SnackBarType.info,
        //  isBold: true,
        //);
        return 'en'; // Default value if the file does not exist
      }
    } catch (e) {
      // Handle any errors that occur during file operations
      ////developer.log("Error reading settings file: $e");
      showSnackbar(
        // ignore: use_build_context_synchronously
        context,
        "Error getting language setting: $e",
        type: SnackBarType.error,
        isBold: true,
      );
      return 'en'; // Default value in case of error
    }
  }

  //* Set the language setting in the user settings file called settings.json
  static Future<bool?> setLanguage(LanguageType language, BuildContext context) async {
    //? Get the path to the application documents directory
    File file = await _localSettingsFile;

    //? Tries to write to the file, if it can't do it, catch the exception
    try {
      if (!await file.exists()) {
        // If the file does not exist, create it with the default value
        Map<String, dynamic> json = {'language': Language.getLanguageCode(language)};
        await file.writeAsString(jsonEncode(json));
        //showSnackbar(
        //  // ignore: use_build_context_synchronously
        //  context,
        //  "Language setting file created with default value ${Language.getLanguageName(language)}",
        //  type: SnackBarType.info,
        //  isBold: true,
        //);
        return true; // Return true if the file was created successfully
      }
      String contents = await file.readAsString();

      // Parse the JSON string to get the language value
      Map<String, dynamic> json = jsonDecode(contents);

      // Update the language value
      json['language'] = Language.getLanguageCode(language);

      // Write the updated JSON string to the file
      await file.writeAsString(jsonEncode(json));

      showSnackbar(
        // ignore: use_build_context_synchronously
        context,
        "Language set to ${Language.getLanguageName(language)}",
        type: SnackBarType.success,
        isBold: true,
      );

      return true;
    } catch (e) {
      // Handle any errors that occur during file operations
      ////developer.log("Error writing settings file: $e");
      showSnackbar(
        // ignore: use_build_context_synchronously
        context,
        "Error setting language: $e",
        type: SnackBarType.error,
        isBold: true,
      );
      return null;
    }
  }

  static Future<bool> getUseSecureStorage(BuildContext context) async {
    //? Get the path to the application documents directory
    File file = await _localSettingsFile;

    try {
      //? Check if the file exists
      if (await file.exists()) {
        String contents = await file.readAsString();

        // Parse the JSON string to get the useSecureStorage value
        Map<String, dynamic> json = jsonDecode(contents);

        bool useSecureStorage = json['useSecureStorage'] ?? false; // Default to false if not found

        //showSnackbar(
        //  // ignore: use_build_context_synchronously
        //  context,
        //  "Use secure storage setting retrieved: $useSecureStorage",
        //  type: SnackBarType.success,
        //  isBold: true,
        //);
        return useSecureStorage;
      } else {
        file.createSync(); // Create the file if it doesn't exist
        Map<String, dynamic> json = {'useSecureStorage': false}; // Default value
        file.writeAsStringSync(jsonEncode(json));
        return false; // Default value if the file does not exist
      }
    } catch (e) {
      showSnackbar(
        // ignore: use_build_context_synchronously
        context,
        "Error getting use secure storage setting: $e",
        type: SnackBarType.error,
        isBold: true,
      );
      return false; // Default value in case of error
    }
  }

  static Future<bool?> setUseSecureStorage(bool value, BuildContext context) async {
    //? Get the path to the application documents directory
    File file = await _localSettingsFile;

    try {
      if (!await file.exists()) {
        // If the file does not exist, create it with the default value
        Map<String, dynamic> json = {'useSecureStorage': value};
        await file.writeAsString(jsonEncode(json));
        return value; // Return the value if the file was created successfully
      }

      String contents = await file.readAsString();

      // Parse the JSON string to get the useSecureStorage value
      Map<String, dynamic> json = jsonDecode(contents);

      // Update the useSecureStorage value
      json['useSecureStorage'] = value;

      // Write the updated JSON string to the file
      await file.writeAsString(jsonEncode(json));

      showSnackbar(
        // ignore: use_build_context_synchronously
        context,
        "Use secure storage set to $value",
        type: SnackBarType.success,
        isBold: true,
      );

      return value;
    } catch (e) {
      showSnackbar(
        // ignore: use_build_context_synchronously
        context,
        "Error setting use secure storage: $e",
        type: SnackBarType.error,
        isBold: true,
      );
      return null;
    }
  }
}
