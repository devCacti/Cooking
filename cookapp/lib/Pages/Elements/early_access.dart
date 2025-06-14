import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget earlyAccess(BuildContext context) {
  final loc = AppLocalizations.of(context)!;

  return Padding(
    padding: const EdgeInsets.only(left: 16, top: 30, right: 16),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color.fromARGB(19, 115, 115, 115),
      ),
      // Early Access Warning
      child: ListTile(
        title: Text(
          loc.earlyAccess,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        leading: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 30,
        ),
        trailing: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 30,
        ),
      ),
    ),
  );
}
