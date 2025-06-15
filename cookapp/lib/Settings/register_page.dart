import 'package:cookapp/Classes/app_state.dart';
import 'package:provider/provider.dart';
import '../Classes/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context)!;
    final appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.register),
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
            Text(
              loc.identification,
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
                labelText: "${loc.name} *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return loc.please_enter_your_name;
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
                labelText: loc.surnames,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Text(
              loc.credentials,
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
                hintText: loc.username_hint, // e.g., "antonio123"
                labelText: "${loc.username} *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return loc.please_enter_your_username;
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
                hintText: loc.email_hint,
                labelText: "${loc.email} *",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return loc.please_enter_your_email;
                }
                String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                RegExp regex = RegExp(pattern); // ReGex: Regular Expression
                if (!regex.hasMatch(value)) {
                  return loc.please_enter_a_valid_email;
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
                  return loc.please_enter_your_password;
                }
                // At least 6 chars, 1 Capital letter, 1 Number and 1 Special character
                String pattern = r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~.])[A-Za-z\d!@#\$&*~.]{6,}$';
                RegExp regex = RegExp(pattern);
                if (!regex.hasMatch(value)) {
                  return loc.password_conditions_error;
                }
                return null;
              },
            ),
            // Password conditions

            const SizedBox(height: 16.0),
            //* Confirm Password
            TextFormField(
              controller: _confPasswordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _isObscureConf,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: "@Password123",
                labelText: "${loc.confirm_password} *",
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
                  return loc.please_confirm_password;
                }
                if (value != _passwordController.text) {
                  return loc.password_mismatch;
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Text(
              "- ${loc.password_conditions_chars}",
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            Text(
              "- ${loc.password_conditions_numbers}",
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            Text(
              "- ${loc.password_conditions_special}",
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12.0),
            //*Loading Indicator
            if (_isRegistering) const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 12.0),
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

                          await appState.register(newUser, context);

                          setState(() {
                            _isRegistering = false;
                          });

                          if (appState.isLoggedIn) {
                            // If registration is successful, navigate to the home page
                            // ignore: use_build_context_synchronously
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        }
                      },
                child: Text(loc.register),
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
                child: Text(loc.goBack),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
