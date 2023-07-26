import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'user_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _senhaKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final TextEditingController emailController = TextEditingController();
  String login = '';
  String email = '';
  String password = '';
  List<dynamic> user = [];
  List<dynamic> userCrs = []; //Credenciais do utilizador
  bool isUser = false;
  bool isPassword = true;
  int tentativas = 0;
  //Não implementado
  nImpl(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(
          'Não implementado',
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: const Text(
          'Esta funcionalidade ainda não foi implementada',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
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
                controller: emailController,
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
                // Add a validator to check if the email address is valid
                // when the user submits the form
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  } else if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  } else {
                    userExists('?email=$email').then((value) {
                      setState(() {
                        user = value;
                        print(user);
                        isUser = true;
                        isPassword = true;
                      });
                    });
                    userExists('?email=$email&password=$password').then((value) {
                      if (user.isNotEmpty) {
                        if (user[0]['email'] == email && user[0]['password'] == password) {
                          print('Login Yes');
                          saveUserLocal(true, user[0]['name'], email);
                          Navigator.pop(context);
                        } else {
                          print('Login No');
                          isPassword = false;
                          _senhaKey.currentState!.validate();
                          isPassword = true;
                        }
                      }
                    });
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: TextFormField(
                key: _senhaKey,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a sua palavra-passe';
                  } else if (!isPassword) {
                    return 'Palavra-passe incorreta';
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
                              _emailKey.currentState!.validate();
                              _senhaKey.currentState!.validate();
                              /*
                              userExists('?password=$password').then((value) {
                                setState(() {
                                  _senhaKey.currentState!.validate();
                                });
                                // ignore: avoid_print
                                print(user[0]['name']);
                              });*/
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
