import 'package:flutter/material.dart';
import '../Classes/user.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLogged = false;
  bool attemptingLogin = false;

  bool hidePassword = true;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (isLogged) {
      Navigator.pop(context);
    }
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final Login login = Login(email: email, password: password);

      // Makes the login request
      // And stores the token in a file
      login.send().then((value) {
        if (value) {
          setState(() {
            isLogged = true;
            attemptingLogin = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar Sessão"), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Icon(
              Icons.login_rounded,
              size: 75,
              shadows: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                  offset: Offset(5.0, 5.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0), // Add space between the fields
            const Text(
              "Log In",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0), // Add space between the fields
            //* Email field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "exemplo@email.com",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded borders
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Por favor insira o seu email";
                }
                String pattern =
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                RegExp regex = RegExp(pattern);
                if (!regex.hasMatch(value)) {
                  return "Por favor insira um email válido";
                }
                return null;
              },
            ),

            const SizedBox(height: 16.0), // Add space between the fields
            //* Password field
            TextFormField(
              controller: _passwordController,
              obscureText: hidePassword,

              decoration: InputDecoration(
                labelText: "Password",
                hintText: "@Password123",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded borders
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8, top: 1),
                  child: IconButton(
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Por favor insira a sua password";
                }
                return null;
              },
              onFieldSubmitted: (String value) {
                login();
              },
            ),
            const SizedBox(height: 16.0),
            const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 28.0,
                  color: Colors.grey,
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    softWrap: true,
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    "A sua conta permanecerá ativa até sair, ou se mudar a palavra-passe.",
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      child: const Text("Registar"),
                      onPressed: () {
                        Navigator.replace(
                          context,
                          oldRoute: ModalRoute.of(context)!,
                          newRoute: PageRouteBuilder(
                            pageBuilder: (
                              BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                            ) {
                              return const RegisterPage();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 32.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: login,
                      child: const Text("Log In"),
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
