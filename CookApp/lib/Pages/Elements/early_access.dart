import 'package:flutter/material.dart';

Widget earlyAccess = Padding(
  padding: const EdgeInsets.only(left: 16, top: 30, right: 16),
  child: Material(
    shadowColor: Colors.black45,
    elevation: 5,
    color: const Color.fromARGB(45, 234, 234, 234),
    borderRadius: BorderRadius.circular(50),
    // Early Access Warning
    child: const ListTile(
      title: Text(
        'ACESSO ANTECIPADO',
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
      subtitle: Text(
        'Pode perder tudo o que tiver durante esta fase!',
        style: TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      ),
      leading: Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
      trailing: Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
    ),
  ),
);
