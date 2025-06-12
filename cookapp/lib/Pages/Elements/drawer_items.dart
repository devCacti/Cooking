import 'package:cookapp/Classes/user.dart';
import 'package:cookapp/Pages/Elements/drawer_header.dart';
import 'package:cookapp/Pages/Elements/logged_in_settings.dart';
import 'package:cookapp/Settings/login_page.dart';
import 'package:cookapp/Settings/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget getDrawerItems(BuildContext context, User? user) {
  final loc = AppLocalizations.of(context)!;

  return user != null
      ? loggedInSettings(context, user)
      : ListView(
          children: [
            anonymousDrawerHeader,
            //* Login and Register buttons
            ListTile(
              title: Text(loc.login),
              leading: const Icon(Icons.login),
              onTap: () {
                //LoginPage is the page that we want to open on click.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                ).then((value) {});
              },
            ),
            ListTile(
              title: Text(loc.register),
              leading: const Icon(Icons.app_registration),
              onTap: () {
                //RegisterPage is the page that we want to open on click.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ),
                );
              },
            ),
            //* Divider
            const Divider(),
            //* Go back button
            ListTile(
              title: Text(loc.goBack),
              leading: const Icon(Icons.arrow_back),
              onTap: () {
                //? Twice so that it closes the drawer and then the page
                Navigator.pop(context); // Close the drawer
                Navigator.pop(context); // Close the page
              },
            ),
          ],
        );
}
