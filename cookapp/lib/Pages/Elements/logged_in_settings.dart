import 'package:cookapp/Classes/app_state.dart';
import 'package:cookapp/Pages/Elements/drawer_header.dart';
import 'package:flutter/material.dart';
import 'package:cookapp/Functions/show_conf_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Widget loggedInSettings(BuildContext context) {
  final appState = Provider.of<AppState>(context, listen: false);
  final loc = AppLocalizations.of(context)!;
  return Column(
    children: [
      drawerHeader(appState.user!),
      //* Privacy
      const Text(
        "Nenhuma definição disponível",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12.0,
        ),
      ),
      const SizedBox(height: 10.0),
      ListTile(
        title: Text(loc.privacy),
        leading: const Icon(Icons.remove_red_eye),
        onTap: null,
      ),
      //* Account Details
      ListTile(
        title: Text(loc.account_details),
        leading: const Icon(Icons.account_circle),
        onTap: null,
      ),
      //* About
      ListTile(
        title: Text(loc.about),
        leading: const Icon(Icons.info),
        onTap: null,
      ),
      //* Divider
      const Divider(),
      ListTile(
        title: Text(loc.logout),
        leading: const Icon(
          Icons.logout,
          color: Colors.red,
        ),
        onTap: () async {
          final navigator = Navigator.of(context);
          await showConfDialog(
            context,
            "Tem a certeza que quer terminar sessão?",
          ).then((value) async {
            if (value) {
              // ignore: use_build_context_synchronously
              appState.logout(context);

              if (navigator.canPop()) {
                navigator.pop();
              }
              // Close the drawer if open, then the page if possible
            }
          });
        },
      ),
    ],
  );
}
