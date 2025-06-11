import 'package:cookapp/Classes/user.dart';
import 'package:flutter/material.dart';

UserAccountsDrawerHeader drawerHeader(User user) {
  String name = "${user.name} ${user.surname ?? ""}";

  return UserAccountsDrawerHeader(
    accountName: Text(name == " " ? "Sem Nome" : name),
    accountEmail: Text("@${user.username}" == "@" ? "Sem Username" : "@${user.username}"),
    currentAccountPicture: const CircleAvatar(
      child: Icon(Icons.person_rounded, size: 42.0),
    ),
    decoration: const BoxDecoration(
      color: Colors.deepPurpleAccent,
    ),
  );
}

const anonymousDrawerHeader = UserAccountsDrawerHeader(
  decoration: BoxDecoration(
    color: Colors.blueGrey,
  ),
  accountName: Text("Utilizador Anónimo"),
  accountEmail: Text("Faça logon para aceder aos serviços", style: TextStyle(color: Colors.orange)),
  currentAccountPicture: CircleAvatar(
    child: Icon(Icons.person, size: 42.0),
  ),
);
