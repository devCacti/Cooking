import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showConfDialog(BuildContext context) {
  return showCupertinoDialog<bool>(
    context: context,
    builder: (context) => Theme(
      data: ThemeData(
          brightness: Brightness.dark,
          textTheme: const TextTheme(
              titleMedium: TextStyle(
            color: Colors.red,
          ))),
      child: CupertinoAlertDialog(
        title: const Text(
          'Confirmação',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: const Text(
          'Tem a certeza que pretende sair?',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          CupertinoDialogAction(
              child: const Text(
                'Sim',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              }),
          CupertinoDialogAction(
            child: const Text(
              'Não',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    ),
  ).then((value) => value ?? false);
}
