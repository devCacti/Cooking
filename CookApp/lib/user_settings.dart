import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
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
            onPressed: () {
              nImpl(context);
            },
            child: const Text(' Login ', style: TextStyle(fontSize: 26, color: Colors.white))),
        OutlinedButton(
            onPressed: () {
              nImpl(context);
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: const BorderSide(color: Colors.green, width: 1),
            ),
            child: const Text(' Registar ', style: TextStyle(fontSize: 26))),
      ],
    );
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
        title: Text('${selectedItem[_selectedIndex.value]}  - (Não implementado)'),
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
                label: Text(selectedItem[index], style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          //Mostra o que está dentro da função UserSettings
          Expanded(
            child: Center(
              child: selectedItem[_selectedIndex.value] == "Perfil" ? userSettings(context) : null,
            ),
          ),
        ],
      ),
    );
  }
}
