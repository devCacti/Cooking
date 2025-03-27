import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'server_info.dart';

const storage = FlutterSecureStorage();

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

  Future<bool> send() async {
    print('Logging in with email: $email and password: $password');

    // Do an API call to the server to login
    var request =
        http.MultipartRequest('POST', Uri.parse('$url/Account/AppLogin'));
    request.fields
        .addAll({'email': email, 'password': password, 'remember me': 'true'});

    //request.headers.addAll(headers); // no headers needed, we only need to get the cookie from the response

    var response = await request.send();
    if (response.statusCode == 200) {
      // if success field is true, save the user data
      var responseBody = await response.stream.bytesToString();

      // Check if it contains the success field and if it has the value true
      if (responseBody.contains('success":true')) {
        print('Login successful');

        // Get the cookie from the response
        var cookie = response.headers['set-cookie'];
        print('Cookie: $cookie');

        // Get the user data from the response
        var username = responseBody.split('username":"')[1].split('"')[0];
        var name = responseBody.split('name":"')[1].split('"')[0];
        var surname = responseBody.split('surname":"')[1].split('"')[0];
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
        await user.save();
        return true;
      } else {
        print('Login failed');
        print('Response: $responseBody');
        return false;
      }
    } else {
      print(" ---> (0002) ${response.reasonPhrase}");
      return false;
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

  Future<bool> register() async {
    if (password != confirmPassword) {
      print('Passwords do not match');
      return false;
    }
    print('Registering with email: $email, username: $username, name: $name');

    // Do an API call to the server to register
    var request =
        http.MultipartRequest('POST', Uri.parse('$url/Account/AppRegister'));
    request.fields.addAll({
      'email': email,
      'username': username,
      'password': password,
      'confirmPassword': confirmPassword,
      'name': name,
      'surname': surname ?? '',
      //'phone': phone ?? '',
    });

    //request.headers.addAll(headers); // no headers needed, we only need to get the cookie from the response

    var response = await request.send();
    if (response.statusCode == 200) {
      // if success field is true, save the user data
      var responseBody = await response.stream.bytesToString();

      // Check if it contains the success field and if it has the value true
      if (responseBody.contains('success":true')) {
        print('Register successful');

        // Get the cookie from the response
        var cookie = response.headers['set-cookie'];
        print('Cookie: $cookie');

        // Get the user data from the response
        var username = responseBody.split('username":"')[1].split('"')[0];
        var name = responseBody.split('name":"')[1].split('"')[0];
        var surname = responseBody.split('surname":"')[1].split('"')[0];
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
        await user.save();

        return true;
      } else {
        print('Register failed');
        print('Response: $responseBody');
        return false;
      }
    } else {
      print(" ---> (0003) ${response.reasonPhrase}");
      return false;
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
    return User(cookie: '', guid: '', email: '', username: '', name: '');
  }

  Future<User> getInstance() async {
    // Returns the information about the user that is saved in the user.json file
    cookie = await storage.read(key: 'cookie') ?? '';
    guid = await storage.read(key: 'guid') ?? '';
    email = await storage.read(key: 'email') ?? '';
    username = await storage.read(key: 'username') ?? '';
    name = await storage.read(key: 'name') ?? '';
    surname = await storage.read(key: 'surname') ?? '';

    print('Cookie: $cookie');
    print('Guid: $guid');
    print('Email: $email');
    print('Username: $username');
    print('Name: $name');
    print('Surname: $surname');

    //! It's triggering a terrible error that doesn't allow app manipulation
    //! [ERROR:flutter/shell/platform/windows/task_runner_window.cc(56)] Failed to post message to main thread.
    //!if (guid != '') {
    //!  return User.defaultU();
    //!}

    return this;
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
    var request = http.Request('GET', Uri.parse('$url/Account/AmILoggedIn'));
    request.headers.addAll({'cookie': cookie});

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        //print(" ---> ${await response.stream.bytesToString()}");

        // if success field is true, save the user data
        var responseBody = await response.stream.bytesToString();
        if (responseBody.contains('success":true')) {
          print('Cookie is valid');
          return true;
        } else {
          print('Cookie is invalid');
          print('Response: $responseBody');
          return false;
        }
      } else {
        print(" ---> (0004) ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> delete() async {
    // Remove data from the secure storage
    try {
      await storage.delete(key: 'cookie');
      await storage.delete(key: 'guid');
      await storage.delete(key: 'email');
      await storage.delete(key: 'username');
      await storage.delete(key: 'name');
      await storage.delete(key: 'surname');
    } catch (e) {
      print('Deletting Error: $e');
      return false;
    }

    return true;
  }

  // Save to local storage (user.json)
  Future<void> save() async {
    print('Saving user data to the secure storage');
    print('Cookie: $cookie');
    print('Guid: $guid');
    print('Email: $email');
    print('Username: $username');
    print('Name: $name');
    print('Surname: $surname');
    // Save the user data to the secure storage
    try {
      await storage.write(key: 'cookie', value: cookie);
      await storage.write(key: 'guid', value: guid);
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'username', value: username);
      await storage.write(key: 'name', value: name);
      await storage.write(key: 'surname', value: surname ?? '');
    } catch (e) {
      print('writting Error: $e');
    }

    print('Saved user data to the secure storage');
  }
}
