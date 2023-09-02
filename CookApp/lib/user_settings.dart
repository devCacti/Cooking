import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/list_favoritas.dart';
import 'login_page.dart';
import 'user_data.dart';
import 'register_page.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> with RestorationMixin {
  final RestorableInt _selectedIndex = RestorableInt(0);

  @override
  String get restorationId => 'user_settings';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex, 'selected_index');
  }

  List<dynamic> user = [];

  @override
  void initState() {
    super.initState();
    loadUserLocal().then((userData) {
      setState(() {
        user = userData;
      });
    });
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = <String>[
      'Perfil',
      'Definições',
      'Privacidade',
    ];
    final selectedIcon = <IconData>[
      Icons.person,
      Icons.settings,
      Icons.privacy_tip,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedItem[_selectedIndex.value]),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex.value,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex.value = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: List.generate(
              selectedItem.length,
              (index) => NavigationRailDestination(
                icon: Icon(selectedIcon[index], size: 30),
                selectedIcon: Icon(selectedIcon[index], size: 35),
                label: Text(selectedItem[index],
                    style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          //Mostra o que está dentro da função UserSettings
          Expanded(
            child: Center(
              child: FutureBuilder<List<dynamic>>(
                future: loadUserLocal(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading screen while the data is being loaded
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Handle the error
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Use the user data to build your UI
                    List<dynamic> user = snapshot.data!;
                    return selectedItem[_selectedIndex.value] == "Perfil"
                        ? user[0]['islogin']
                            ? display(context)
                            : userSettings(context)
                        : const SizedBox.shrink();
                  } else {
                    // Handle the case where the data is empty
                    return const Text('No user data found');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget userSettings(BuildContext context) {
  //Faz animação de entrada de estilo scroll
  return Column(
    children: [
      const SizedBox(height: 20),
      const Text(
        'Credênciais',
        style: TextStyle(fontSize: 36),
      ),
      const SizedBox(height: 10),
      const Divider(thickness: 2, indent: 40, endIndent: 40),
      const SizedBox(height: 20),
      FilledButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        },
        child: const Text(
          ' Login ',
          style: TextStyle(fontSize: 26, color: Colors.white),
        ),
      ),
      const Column(
        children: [
          SizedBox(height: 5),
          SizedBox(
            child: Text(
              'ou',
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
      OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: const BorderSide(color: Colors.green, width: 1),
          ),
          child: const Text(' Registar ', style: TextStyle(fontSize: 26))),
    ],
  );
}

//Não implementado
nImpl(BuildContext context) {
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text(
        'Não implementado',
        style: TextStyle(
          color: Colors.red,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      content: const Text(
        'Esta funcionalidade ainda não foi implementada',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text('OK', style: TextStyle(color: Colors.blue)),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

Widget display(BuildContext context) {
  return FutureBuilder<List<dynamic>>(
    future: loadUserLocal(),
    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      if (snapshot.hasData) {
        final user = snapshot.data!;
        TextEditingController nome =
            TextEditingController(text: user[0]['name']);
        TextEditingController email =
            TextEditingController(text: user[0]['email']);
        return Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Credênciais',
              style: TextStyle(fontSize: 36),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 2, indent: 75, endIndent: 75),
            const SizedBox(height: 20),
            SizedBox(
              //half of screen width - half of widget width
              width: MediaQuery.of(context).size.width / 2 + 50,
              height: 100,
              child: TextFormField(
                enabled: false,
                controller: nome,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                ),
              ),
            ),
            SizedBox(
              //half of screen width - half of widget width
              width: MediaQuery.of(context).size.width / 2 + 50,
              height: 100,
              child: TextFormField(
                enabled: false,
                controller: email,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Endereço de email',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton.icon(
              //border color
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
              ),
              onPressed: () {
                showConfirmationDialog(context).then((value) {
                  if (value) {
                    saveUserLocal(false, 'none', 'none');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    ).then((value) {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/user_settings'));

                      refreshIndicatorKey.currentState!.show().then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logout efetuado com sucesso'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                    });
                  }
                });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              label: const Text(
                'Logout',
                style: TextStyle(fontSize: 26, color: Colors.red),
              ),
            ),
          ],
        );
      } else if (snapshot.hasError) {
        return const Text('Erro ao carregar as credenciais do usuário');
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}

Future<bool> showConfirmationDialog(BuildContext context) async {
  bool confirm = false;
  await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: ThemeData(
          brightness: Brightness.dark,
          textTheme: const TextTheme(
            titleMedium: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        child: CupertinoAlertDialog(
          title: const Text(
            'Terminar sessão?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Tem a certeza que deseja terminar a sessão?',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                confirm = true;
                Navigator.pop(context);
              },
              child: const Text('Sim'),
            ),
          ],
        ),
      );
    },
  );
  return confirm;
}
