import 'package:flutter/material.dart';
import 'user_data.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _senhaKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  String login = '';
  String email = '';
  String password = '';
  List<dynamic> user = [];
  List<dynamic> userCrs = []; //Credenciais do utilizador
  bool isUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registo'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_rounded,
              size: 100,
              color: Colors.grey,
            ),
            isUser
                ? user.isEmpty
                    ? const Text(
                        'Utilizador não encontrado',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        '${user[0]['name']}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      )
                : const Text(
                    'Bem vindo!',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                    ),
                  ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextFormField(
                key: _emailKey,
                validator: (value) {
                  print('Validator: $value : $user');
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um email';
                  } else if (user[0]['name'] != '') {
                    return 'Email já registado';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  labelText: 'Email',
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextFormField(
                key: _senhaKey,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma palavra-passe';
                  }
                  return null;
                },
                onChanged: (value) {
                  _senhaKey.currentState!.validate();
                  setState(() {
                    password = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  labelText: 'Palavra-passe',
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Voltar',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: email == ''
                          ? null
                          : () {
                              userExists('?email=$email').then((value) {
                                setState(() {
                                  user = value;
                                  print('User: $user');
                                  isUser = true;
                                  _emailKey.currentState!.validate();
                                });
                              });
                            },
                      child: const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
