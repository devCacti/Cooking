import '../Classes/user_data.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isRegistering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registo"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Nome",
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Por favor insira o seu nome";
                }
                return null;
              },
            ),
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
              onPressed: _isRegistering
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isRegistering = true;
                        });
                        final String name = _nameController.text;
                        final String email = _emailController.text;
                        final String password = _passwordController.text;
                        final bool isRegistered =
                            await UserData.register(name, email, password);
                        setState(() {
                          _isRegistering = false;
                        });
                        if (isRegistered) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Erro no registo"),
                            ),
                          );
                        }
                      }
                    },
              child: const Text("Registar"),
            ),
          ],
        ),
      ),
    );
  }
}
