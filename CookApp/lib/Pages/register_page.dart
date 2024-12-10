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
  final TextEditingController _surnamesController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confPasswordController = TextEditingController();
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
            Icon(
              Icons.person_add_rounded,
              size: 100.0,
              color: Theme.of(context).primaryColor,
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
                labelText: "Nome",
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
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
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            // Divider
            const Divider(
              color: Colors.black,
              thickness: 1,
              height: 0.1,
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 24.0),
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
                labelText: "Username",
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
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
                labelText: "Email",
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Por favor insira o seu email";
                }
                String pattern =
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                RegExp regex = RegExp(pattern); // ReGex: Regular Expression
                if (!regex.hasMatch(value)) {
                  return 'Por favor insira um email válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 32.0),
            // Divider
            const Divider(
              color: Colors.black,
              thickness: 1,
              height: 0.1,
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 32.0),

            //* Password
            TextFormField(
              obscureText: true,
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "@Password123",
                labelText: "Password",
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Por favor insira a sua password";
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            //* Confirm Password
            TextFormField(
              controller: _confPasswordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: "@Password123",
                labelText: "Confirmar Password",
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 16.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
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
            if (_isRegistering)
              const Center(child: CircularProgressIndicator()),
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
                          final String name = _userNameController.text;
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
