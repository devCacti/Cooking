import 'dart:io';

import 'package:path_provider/path_provider.dart' as path_provider;

/// A utility class to handle file operations in the app's documents directory.
class AppDocuments {
  /// Returns the path to the app's documents directory.
  static Future<String> get path async {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Returns a [File] object for the given [fileName] in the app's documents directory.
  static Future<File> getFile(String fileName) async {
    final path = await AppDocuments.path;
    return File('$path/$fileName');
  }
}
