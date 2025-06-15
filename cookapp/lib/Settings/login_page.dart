import 'package:cookapp/Classes/app_state.dart';
import 'package:cookapp/Classes/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar Sessão"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.login_rounded,
                size: 75.0,
                color: Theme.of(context).primaryColor,
                shadows: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    offset: Offset(5.0, 5.0),
                  ),
                ],
              ),
              const SizedBox(height: 32.0), // Add space between the fields
              //* Email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "exemplo@email.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0), // Rounded borders
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor insira o seu email";
                  }
                  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
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
                obscureText: true, // Hide the password
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "@Password123",
                  // Adjust padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0), // Rounded borders
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
              const Row(
                children: [
                  Icon(
                    Icons.perm_device_information_outlined,
                    size: 28.0,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.grey,
                      ),
                      "A sua conta permanecerá ativa até sair, ou se mudar a palavra-passe.",
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        child: const Text("Não tenho conta."),
                        onPressed: () {
                          Navigator.replace(
                            context,
                            oldRoute: ModalRoute.of(context)!,
                            newRoute: PageRouteBuilder(
                                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                              return const RegisterPage();
                            }),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 32.0),
                    Expanded(
                      child: ElevatedButton(
                        child: const Text("Log In"),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final String email = _emailController.text;
                            final String password = _passwordController.text;
                            final Login login = Login(email: email, password: password);

                            // Makes the login request
                            // And stores the token in a file
                            await appState.login(login, context).then((value) {
                              if (appState.isLoggedIn) {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              //ElevatedButton(
              //  onPressed: () {
              //    // Simulate an error for demonstration purposes
              //    showSnackbar(context, 'This is a simulated error message.', type: SnackBarType.error, isBold: true);
              //  },
              //  style: ElevatedButton.styleFrom(
              //    backgroundColor: Colors.red, // Button color
              //    foregroundColor: Colors.white, // Text color
              //  ),
              //  child: const Text("Trigger Error"),
              //),
            ],
          ),
        ),
      ),
    );
  }
}
