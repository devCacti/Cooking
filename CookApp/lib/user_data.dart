// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path_provider;

String sv = 'http://192.168.31.82:3000/users';
Future<List<dynamic>> userExists(String test) async {
  final response = await http.get(Uri.parse('$sv$test'));
  List<dynamic> users = [];
  if (response.statusCode == 200) {
    print('Code: ${response.statusCode} - Accepted !');
    users = jsonDecode(response.body);
  } else {
    // ignore: avoid_print
    print('${response.statusCode} - FAILED to load users !');
  }
  return users;
}

Future<File> get _localFile async {
  final directory = await path_provider.getApplicationDocumentsDirectory();
  return File('${directory.path}/userInfoTests1.json');
}

//guardar dados do utilizador num ficheiro local
Future<void> saveUserLocal(bool? login, String? name, String? email) async {
  try {
    final file = await _localFile;
    List<dynamic> jsonList = [];
    if (login != null && name != null && email != null) {
      jsonList.add({'islogin': login, 'name': name, 'email': email});
    }
    await file.writeAsString(json.encode(jsonList));
  } catch (e) {
    throw Exception('Failed to save recipe: $e');
  }
}

Future<List<dynamic>> loadUserLocal() {
  try {
    return _localFile.then((file) async {
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList;
    });
  } catch (e) {
    throw Exception('Failed to load recipe: $e');
  }
}

//guardar dados do utilizador na base de dados
Future<void> saveUser(String name, String email) async {
  final response = await http.post(
    Uri.parse(sv),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      <String, String>{
        'name': name,
        'email': email,
      },
    ),
  );
  if (response.statusCode == 201) {
    // ignore: avoid_print
    print('Code: ${response.statusCode} - Accepted !');
  } else {
    // ignore: avoid_print
    print('${response.statusCode} - FAILED to save user !');
  }
}
