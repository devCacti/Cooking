import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:cookapp/Classes/app_state.dart';
import 'package:cookapp/Classes/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';
import 'server_info.dart';

const storage = FlutterSecureStorage(
  // ignore: deprecated_member_use
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

// This file contains the classes for the user, login and register

class Login {
  String email;
  String username;
  String password;
  String name;
  String? surname;
  //String? phone; //! Not sent

  Login({
    required this.email,
    required this.password,
    this.username = '',
    this.name = '',
    this.surname,
    //this.phone,
  });

  Future<User> send(BuildContext context) async {
    final appState = context.read<AppState>();
    //developer.log('Logging in with email: $email and password: $password');

    // Do an API call to the server to login
    var request = http.MultipartRequest('POST', Uri.parse('${ServerInfo.url}/Account/AppLogin'));
    request.fields.addAll({
      'email': email,
      'password': password,
      'remember me': 'true',
    });

    //request.headers.addAll(headers); // no headers needed, we only need to get the cookie from the response

    var response = await request.send();
    if (response.statusCode == 200) {
      // if success field is true, save the user data
      var responseBody = await response.stream.bytesToString();

      // Check if it contains the success field and if it has the value true
      if (responseBody.contains('success":true')) {
        //developer.log('Login successful');

        // Get the cookie from the response
        var cookie = response.headers['set-cookie'];

        //developer.log('Response: $responseBody');

        // Get the user data from the response
        var username = responseBody.split('username":"')[1].split('"')[0];

        var name = "";
        if (responseBody.contains('name":"')) {
          name = responseBody.split('name":"')[1].split('"')[0];
        }
        var surname = "";
        if (responseBody.contains('surname":"')) {
          surname = responseBody.split('surname":"')[1].split('"')[0];
        }
        var guid = responseBody.split('id":"')[1].split('"')[0];

        // Save the user data to user.json
        // ignore: use_build_context_synchronously
        User user = User(
          cookie: cookie!,
          guid: guid,
          email: email,
          username: username,
          name: name,
          surname: surname,
        );

        await user.save(appState.useSecureStorage);

        return user;
      } else {
        //developer.log('Login failed');
        //developer.log('Response: $responseBody');
        return User.defaultU();
      }
    } else {
      //developer.log(" ---> (0002) ${response.reasonPhrase}");
      return User.defaultU();
    }
  }
}

class Register {
  String email;
  String username;
  String password;
  String confirmPassword;
  String name;
  String? surname;
  //String? phone; //! Not sent

  Register({
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.name,
    this.surname,
    //this.phone,
  });

  Future<User> send(BuildContext context) async {
    final appState = context.read<AppState>();

    if (password != confirmPassword) {
      //developer.log('Passwords do not match');
      showSnackbar(
        // ignore: use_build_context_synchronously
        context,
        'Error: Passwords do not match',
        type: SnackBarType.error,
        isBold: true,
      );
      return User.defaultU();
    }
    //developer.log('Registering with email: $email, username: $username, name: $name');

    // Do an API call to the server to register
    var request = http.MultipartRequest('POST', Uri.parse('${ServerInfo.url}/Account/AppRegister'));
    request.fields.addAll({
      'email': email.toString().toLowerCase(),
      'username': username.toString(),
      'password': password.toString(),
      'confirmPassword': confirmPassword.toString(),
      'name': name.toString(),
      'surname': surname?.toString() ?? '',
      //'phone': phone ?? '',
    });

    //request.headers.addAll(headers); // no headers needed, we only need to get the cookie from the response

    var response = await request.send();
    if (response.statusCode == 200) {
      // if success field is true, save the user data
      var responseBody = await response.stream.bytesToString();

      // Check if it contains the success field and if it has the value true
      if (responseBody.contains('success":true')) {
        developer.log('Register successful');

        // Get the cookie from the response
        var cookie = response.headers['set-cookie'];
        //developer.log('Cookie: $cookie');

        // Get the user data from the response
        var username = responseBody.split('username":"')[1].split('"')[0];
        var name = responseBody.split('name":"')[1].split('"')[0];
        var surname = "";
        if (responseBody.contains('surname":"')) {
          surname = responseBody.split('surname":"')[1].split('"')[0];
        }
        var guid = responseBody.split('id":"')[1].split('"')[0];

        // Save the user data to user.json
        // ignore: use_build_context_synchronously
        User user = User(
          cookie: cookie!,
          guid: guid,
          email: email,
          username: username,
          name: name,
          surname: surname,
        );
        await user.save(appState.useSecureStorage);

        return user;
      } else {
        showSnackbar(
          // ignore: use_build_context_synchronously
          context,
          'Error: ${responseBody.split('"description":"')[1].split('"')[0]}',
          type: SnackBarType.error,
          isBold: true,
        );
        developer.log("User Registration Error: ${responseBody.split('"description":"')[1].split('"')[0]}");
        developer.log('Response: $responseBody');

        //developer.log('Register failed');
        return User.defaultU();
      }
    } else {
      //developer.log(" ---> (0003) ${response.reasonPhrase}");
      showSnackbar(
        // ignore: use_build_context_synchronously
        context,
        'Error: ${response.reasonPhrase}',
        type: SnackBarType.error,
        isBold: true,
      );
      return User.defaultU();
    }
  }
}

// A Class to save user data
class User {
  String cookie;
  String guid;
  String email;
  String username;
  String name;
  String? surname;
  int type = 3;

  //String? phone; //! Not sent

  User({
    this.cookie = '',
    this.guid = '',
    this.email = '',
    this.username = '',
    this.name = '',
    this.surname,
    //this.phone,
  });

  factory User.defaultU() {
    return User(cookie: '', guid: '', email: '', username: '', name: '', surname: null);
  }

  Future<User> getInstance(BuildContext context) async {
    // Returns the information about the user that is saved in the user.json file
    var appState = context.read<AppState>();
    if (appState.useSecureStorage) {
      //developer.log('Using secure storage');
      // Read the user data from the secure storage
      cookie = await storage.read(key: 'cookie') ?? '';
      guid = await storage.read(key: 'guid') ?? '';
      email = await storage.read(key: 'email') ?? '';
      username = await storage.read(key: 'username') ?? '';
      name = await storage.read(key: 'name') ?? '';
      surname = await storage.read(key: 'surname') ?? '';
    } else {
      //developer.log('Using local storage');
      // Read the user data from the local file
      File file = await _localUserFile;
      if (await file.exists()) {
        String contents = await file.readAsString();
        Map<String, dynamic> json = jsonDecode(contents);
        cookie = json['cookie'] ?? '';
        guid = json['guid'] ?? '';
        email = json['email'] ?? '';
        username = json['username'] ?? '';
        name = json['name'] ?? '';
        surname = json['surname'] ?? '';
      } else {
        // If the file does not exist, return a default user
        return User.defaultU();
      }
    }
    //////developer.log('Cookie: $cookie');
    //////developer.log('Guid: $guid');
    //////developer.log('Email: $email');
    //////developer.log('Username: $username');
    //////developer.log('Name: $name');
    //////developer.log('Surname: $surname');

    //! It's triggering a terrible error that doesn't allow app manipulation
    //! [ERROR:flutter/shell/platform/windows/task_runner_window.cc(56)] Failed to post message to main thread.
    //!if (guid != '') {
    //!  return User.defaultU();
    //!}

    return this;
  }

  static Future<User> getUser(BuildContext context) async {
    // Get the user data from the secure storage or local file
    var appState = context.read<AppState>();
    User user = User();
    if (appState.useSecureStorage) {
      //developer.log('Using secure storage');
      user.cookie = await storage.read(key: 'cookie') ?? '';
      user.guid = await storage.read(key: 'guid') ?? '';
      user.email = await storage.read(key: 'email') ?? '';
      user.username = await storage.read(key: 'username') ?? '';
      user.name = await storage.read(key: 'name') ?? '';
      user.surname = await storage.read(key: 'surname') ?? '';
    } else {
      //developer.log('Using local storage');
      File file = await user._localUserFile;
      if (await file.exists()) {
        String contents = await file.readAsString();
        Map<String, dynamic> json = jsonDecode(contents);
        user.cookie = json['cookie'] ?? '';
        user.guid = json['guid'] ?? '';
        user.email = json['email'] ?? '';
        user.username = json['username'] ?? '';
        user.name = json['name'] ?? '';
        user.surname = json['surname'] ?? '';
      } else {
        // If the file does not exist, return a default user
        return User.defaultU();
      }
    }
    return user;
  }

  // Get the user data from a json object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      cookie: json['cookie'],
      guid: json['guid'],
      email: json['email'],
      username: json['username'],
      name: json['name'],
      surname: json['surname'],
    );
  }

  Future<File> get _localUserFile async {
    // Get the local user file path
    var dir = await path_provider.getApplicationDocumentsDirectory();
    return File('${dir.path}/user.json');
  }

  // Convert the user data to a json object
  Map<String, dynamic> toJson() {
    return {
      'cookie': cookie,
      'guid': guid,
      'email': email,
      'username': username,
      'name': name,
      'surname': surname,
    };
  }

  // Validates the cookie by sending a request to the server asking if it is valid, the server returns a response with a success field
  Future<bool> validateCookie() async {
    // Do an API call to the server to validate the cookie, the cookie is set to a header on the request and no body is needed
    var request = http.Request('GET', Uri.parse('${ServerInfo.url}/Account/AmILoggedIn'));
    request.headers.addAll({'cookie': cookie});

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        ////developer.log(" ---> ${await response.stream.bytesToString()}");

        // if success field is true, save the user data
        var responseBody = await response.stream.bytesToString();
        if (responseBody.contains('success":true')) {
          //developer.log('Cookie is valid');
          return true;
        } else {
          //developer.log('Error 0004: ${responseBody.split('"description":"')[1].split('"')[0]}');
          //developer.log('Cookie is invalid');
          return false;
        }
      } else {
        //developer.log('Error 0004: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      //developer.log('Error 0004: $e');
      return false;
    }
  }

  Future<bool> delete(BuildContext context) async {
    // Remove data from the secure storage
    try {
      var appState = context.read<AppState>();
      if (appState.useSecureStorage) {
        //developer.log('Deleting user data from secure storage');
        storage.deleteAll(); // Delete all data from secure storage
      } else {
        // If not using secure storage, delete the local file
        File file = await _localUserFile;
        if (await file.exists()) {
          await file.delete();
        }
      }
      developer.log('User data deleted from secure storage');
    } catch (e) {
      developer.log('Error deleting user data: $e');
      return false;
    }

    return true;
  }

  // Save to local storage (user.json)
  Future<void> save(bool useSecureStorage) async {
    //////developer.log('Saving user data to the secure storage');
    //////developer.log('Cookie: $cookie');
    //////developer.log('Guid: $guid');
    //////developer.log('Email: $email');
    //////developer.log('Username: $username');
    //////developer.log('Name: $name');
    //////developer.log('Surname: $surname');
    // Save the user data to the secure storage
    try {
      if (useSecureStorage) {
        await storage.write(key: 'cookie', value: cookie);
        await storage.write(key: 'guid', value: guid);
        await storage.write(key: 'email', value: email);
        await storage.write(key: 'username', value: username);
        await storage.write(key: 'name', value: name);
        await storage.write(key: 'surname', value: surname ?? '');
      } else {
        // If not using secure storage, save to a file
        File file = await _localUserFile;
        await file.writeAsString(jsonEncode(toJson()));
      }
    } catch (e) {
      //developer.log('writting Error: $e');
    }

    //developer.log('Saved user data to the secure storage');
  }
}
