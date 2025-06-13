import 'package:cookapp/Classes/app_state.dart';
import 'package:provider/provider.dart';

import '../Classes/user.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnamesController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isRegistering = false;
  bool _isObscure = true;
  bool _isObscureConf = true;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
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
            Icon(
              Icons.person_add_rounded,
              size: 100.0,
              shadows: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                  offset: Offset(5.0, 5.0),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            const Text(
              "Identificação",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 12.0),
            //* Name
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                hintText: "António",
                labelText: "Nome *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Por favor insira o seu nome";
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            //* Surnames
            TextFormField(
              controller: _surnamesController,
              decoration: InputDecoration(
                hintText: "da Silva Lopes",
                labelText: "Apelidos",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            const Text(
              "Credenciais",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 12.0),
            //* Username
            TextFormField(
              controller: _userNameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "o_seu_nome",
                labelText: "Username *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Por favor insira o seu nome de utilizador";
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            //* Email
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "exemplo@email.com",
                labelText: "eMail *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Por favor insira o seu email";
                }
                String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                RegExp regex = RegExp(pattern); // ReGex: Regular Expression
                if (!regex.hasMatch(value)) {
                  return 'Por favor insira um email válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 32.0),

            //* Password
            TextFormField(
              obscureText: _isObscure,
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "@Password123",
                labelText: "Password *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Por favor insira a sua password";
                }
                // At least 6 chars, 1 Capital letter, 1 Number and 1 Special character
                String pattern = r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~.])[A-Za-z\d!@#\$&*~.]{6,}$';
                RegExp regex = RegExp(pattern);
                if (!regex.hasMatch(value)) {
                  return '6 caracteres, 1 letra maiús., 1 num. e 1 car. especial';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            //* Confirm Password
            TextFormField(
              controller: _confPasswordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _isObscureConf,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: "@Password123",
                labelText: "Confirmar Password *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_isObscureConf ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscureConf = !_isObscureConf;
                    });
                  },
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Por favor confirme a sua password";
                }
                if (value != _passwordController.text) {
                  return "As passwords não coincidem";
                }
                return null;
              },
            ),
            const SizedBox(height: 48.0),
            //*Loading Indicator
            if (_isRegistering) const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 24.0),
            //* Register Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
              child: ElevatedButton(
                onPressed: _isRegistering
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isRegistering = true;
                          });
                          final Register newUser = Register(
                            name: _nameController.text,
                            surname: _surnamesController.text,
                            username: _userNameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            confirmPassword: _confPasswordController.text,
                          );

                          appState.register(newUser, context);

                          setState(() {
                            _isRegistering = false;
                          });
                        }
                      },
                child: const Text("Registar"),
              ),
            ),
            const SizedBox(height: 24.0),
            //* Go Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Voltar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
