import 'package:cookapp/Classes/app_state.dart';
import 'package:cookapp/Classes/snackbars.dart';
import 'package:cookapp/Pages/Elements/drawer_header.dart';
import 'package:cookapp/Pages/Elements/logged_in_settings.dart';
import 'package:cookapp/Settings/login_page.dart';
import 'package:cookapp/Settings/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Widget getDrawerItems(BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  final appState = Provider.of<AppState>(context, listen: false);

  showSuccessfullyLoggedInSnackbar() {
    showSnackbar(context, loc.login_successful, type: SnackBarType.success, isBold: true);
    //Check if its possible to close the drawer
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Close the drawer
    }
  }

  showSuccessfullyRegisteredSnackbar() {
    showSnackbar(context, loc.register_successful, type: SnackBarType.success, isBold: true);
    //Check if its possible to close the drawer
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Close the drawer
    }
  }

  return appState.isLoggedIn
      ? loggedInSettings(context)
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
                ).then((value) {
                  if (appState.isLoggedIn) {
                    // If the user is logged in, we can show the logged in settings
                    showSuccessfullyLoggedInSnackbar();
                  }
                });
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
                ).then((value) {
                  if (appState.isLoggedIn) {
                    // If the user is logged in, we can show the logged in settings
                    showSuccessfullyRegisteredSnackbar();
                  }
                });
              },
            ),
          ],
        );
}
