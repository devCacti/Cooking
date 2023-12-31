import 'package:flutter/material.dart';

Future<bool> showConfDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
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
        TextButton(
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
          },
        ),
        TextButton(
          child: const Text(
            'Não',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
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
