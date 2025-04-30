import 'package:cookapp/Settings/settings.dart';
import 'package:flutter/material.dart';

Future<bool> showConfDialog(BuildContext context, [String? title]) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Confirmação',
        style: TextStyle(
          color: themeNotifier.value == ThemeMode.dark ? Colors.white : Colors.black,
          fontSize: 24,
        ),
      ),
      content: title != null
          ? Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            )
          : const Text(
              'Tem a certeza que pretende sair? Qualquer alteração não guardada será perdida.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
      actions: [
        TextButton(
          child: const Text(
            'Sim',
            style: TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        TextButton(
          child: Text(
            'Não',
            style: TextStyle(
              fontSize: 18,
              color: themeNotifier.value == ThemeMode.dark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    ),
  ).then((value) => value ?? false);
}
