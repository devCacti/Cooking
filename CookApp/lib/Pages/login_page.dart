import 'package:flutter/material.dart';
import '../Classes/user_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Email",
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Por favor insira o seu email";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: "Password",
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Por favor insira a sua password";
                }
                return null;
              },
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              child: const Text("Entrar"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final String email = _emailController.text;
                  final String password = _passwordController.text;
                  final bool isLogged = await UserData.login(email, password);
                  if (isLogged) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                }
              },
            ),
            const SizedBox(height: 32.0),
            TextButton(
              child: const Text("Registar"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
