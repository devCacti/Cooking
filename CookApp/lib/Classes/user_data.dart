// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path_provider;

String sv = 'http://192.168.1.73:80/';
//    'http://192.168.250.243:80/';
//    'http://192.168.32.178:80/';

class UserData {
  static Future<bool> isLogged() async {
    final String? token = await getToken();
    if (token == null) {
      return false;
    }
    final http.Response response = await http.get(
      Uri.parse('${sv}Account/IsLogged'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      return true;
    }
    return false;
  }

  static Future<String?> getToken() async {
    final Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/token.txt');
    if (file.existsSync()) {
      return file.readAsStringSync();
    }
    return null;
  }

  static Future<void> setToken(String token) async {
    final Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/token.txt');
    file.writeAsStringSync(token);
  }

  static Future<void> removeToken() async {
    final Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/token.txt');
    file.deleteSync();
  }

  static Future<bool> register(
      String name, String email, String password) async {
    final http.Response response = await http.post(
      Uri.parse('${sv}Account/Register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      await setToken(body['token']);
      return true;
    }
    return false;
  }

  static Future<bool> login(String email, String password) async {
    final http.Response response = await http.post(
      Uri.parse('${sv}Account/AppLogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      //await setToken(body['token']);
      if (body['success'] == true) {
        return true;
      }
      print('Response: $body');
    }
    return false;
  }

  // ...

  static Future<void> logout() async {
    final String? token = await getToken();
    if (token == null) {
      return;
    }
    final http.Response response = await http.post(
      Uri.parse('${sv}application/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 5)); // Set timeout of 5 seconds
    if (response.statusCode == 200) {
      await removeToken();
    }
  }
}
