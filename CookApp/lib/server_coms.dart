// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:http/http.dart' as http;

String sv = 'http://192.168.31.82:3000/users';
Future<List<dynamic>> userExists(String test) async {
  final response = await http.get(Uri.parse('$sv$test'));
  List<dynamic> users = [];
  if (response.statusCode == 200) {
    // ignore: avoid_print
    print('Code: ${response.statusCode} - Accepted !');
    // If the server did return a 200 OK response,
    // then parse the JSON.
    users = jsonDecode(response.body);
    // Print the contents of the users variable to the console
    // ignore: avoid_print
    print(users);
  } else {
    // ignore: avoid_print
    print('${response.statusCode} - FAILED to load users !');
  }
  return users;
}
