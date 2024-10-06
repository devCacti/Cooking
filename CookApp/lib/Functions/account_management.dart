//* Save Account Login Data and Valid Token
//? This function will save the user's login data and the token received from the server in a secure container.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

//Secure Storage
const FlutterSecureStorage _storage = FlutterSecureStorage();

// Gets the login token from the secure storage
Future<String> get getLoginToken async {
  final value = await _storage.read(key: "login_token");
  return value ?? "";
}

// Sets the login token in the secure storage
set loginToken(String token) {
  _storage.write(key: "login_token", value: token);
}

Future<String?> get verifToken async {
  return await _storage.read(key: "verification_token");
}

// HTTP Requests
// Login

Future<void> login(String email, String password) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://localhost:44322/Account/AppLogin'));
  request.fields
      .addAll({'email': email, 'password': password, 'remember me': 'true'});

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var token = response.headers['token'];
    loginToken = token!;
  } else {
    print(response.reasonPhrase);
  }
}
