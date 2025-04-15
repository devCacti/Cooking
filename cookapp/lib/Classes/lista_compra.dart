import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
/*
class LstItem {
  final int id;
  final String nome;
  final String? descricao;
  late final bool? done;

  LstItem({required this.id, required this.nome, this.descricao, this.done});

  factory LstItem.fromJson(Map<String, dynamic> json) {
    return LstItem(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      done: json['done'],
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'nome': nome, 'descricao': descricao, 'done': done};
}

Future<File> get _localFile async {
  final directory = await path_provider.getApplicationDocumentsDirectory();
  return File('${directory.path}/testes_list_compras10.json');
}

Future<List<LstItem>> loadItems() async {
  try {
    final file = await _localFile;
    final contents = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(contents);
    final List<LstItem> items =
        jsonList.map((json) => LstItem.fromJson(json)).toList();
    return items;
  } catch (e) {
    return [];
  }
}

Future<void> saveItem(LstItem item) async {
  try {
    final file = await _localFile;
    List<dynamic> jsonList = [];
    try {
      final contents = await file.readAsString();
      jsonList = json.decode(contents);
    } catch (e) {
      jsonList = [];
    }
    jsonList.add(item.toJson());
    await file.writeAsString(json.encode(jsonList));
  } catch (e) {
    throw Exception('Failed to save items to file: $e');
  }
}

Future<File> get _localIdFile async {
  final directory = await path_provider.getApplicationDocumentsDirectory();
  return File('${directory.path}/last_item_id10.txt');
}

Future<int> getNextID() async {
  final file = await _localIdFile;
  try {
    final contents = await file.readAsString();
    final int lastId = int.parse(contents);
    final int nextId = lastId + 1;
    await file.writeAsString('$nextId');
    return nextId;
  } catch (e) {
    await file.writeAsString('1');
    return 1;
  }
}

// ignore: non_constant_identifier_names
Future<int> update_all_items(List<LstItem> items) async {
  try {
    final file = await _localFile;
    await file.writeAsString(json.encode(items));
    return 1;
  } catch (e) {
    throw Exception('Failed to update items: $e');
  }
}
Future<void> deleteItemById(int id) async {
  try {
    final file = await _localFile;
    final contents = await file.readAsString();
    final List<dynamic> jsonList = json.decode(contents);
    final List<LstItem> items =
        jsonList.map((json) => LstItem.fromJson(json)).toList();
    final updatedItems = items.where((item) => item.id != id).toList();
    await file.writeAsString(json.encode(updatedItems));
  } catch (e) {
    throw Exception('Failed to delete item: $e');
  }
}
*/

//!
//! Lista de Compras - PARTE COMPLEXA DO LADO DO UTILIZADOR
//!

class ListItem {
  int? id;
  String nome;
  double preco = 0;
  double quantidade = 1;
  bool checked = false;

  ListItem({
    this.id,
    required this.nome,
    this.preco = 0,
    this.quantidade = 1,
    this.checked = false,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      id: json['id'],
      nome: json['nome'],
      preco: json['preco'],
      quantidade: json['quantidade'],
      checked: json['checked'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'preco': preco,
        'quantidade': quantidade,
        'checked': checked,
      };
}

class Loja {
  int id;
  String nome;
  String? localizacao;

  Loja({
    this.id = 0,
    required this.nome,
    this.localizacao,
  });

  factory Loja.fromJson(Map<String, dynamic> json) {
    return Loja(
      id: json['id'],
      nome: json['nome'],
      localizacao: json['localizacao'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'localizacao': localizacao,
      };

  Future<File> get _localFile async {
    final directory = await path_provider.getApplicationDocumentsDirectory();

    // Create if it doesn't exist already
    if (!await directory.exists()) {
      await directory.create();
    }

    File file = File('${directory.path}\\testes_lojas2$nTry.json');

    if (!await file.exists()) {
      await file.create();
    }

    return file;
  }

  //? Saves new stores to file
  Future<void> save() async {
    try {
      final file = await _localFile;
      List<dynamic> jsonList = [];
      try {
        final contents = await file.readAsString();
        jsonList = json.decode(contents);
      } catch (e) {
        jsonList = [];
      }

      // Check if there is already a store with the same name
      if (jsonList.any((store) => store['nome'] == nome)) {
        return;
      }

      jsonList.add(toJson());
      file.writeAsStringSync(json.encode(jsonList));
    } catch (e) {
      throw Exception('Failed to save items to file: $e');
    }
  }

  //? Loads all stores
  Future<List<Loja>> load() async {
    try {
      final file = await _localFile;

      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();

      if (contents.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(contents);

      final List<Loja> stores =
          jsonList.map((json) => Loja.fromJson(json)).toList();
      return stores;
    } catch (e) {
      return [];
    }
  }

  //? Deletes store by id
  Future<void> deleteById(int id) async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      final List<Loja> stores =
          jsonList.map((json) => Loja.fromJson(json)).toList();
      final updatedStores = stores.where((store) => store.id != id).toList();
      await file.writeAsString(json.encode(updatedStores));
    } catch (e) {
      throw Exception('Failed to delete store: $e');
    }
  }

  //? Updates store by id
  Future<void> updateById(Loja store) async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      final List<Loja> stores =
          jsonList.map((json) => Loja.fromJson(json)).toList();
      final updatedStores = stores.where((s) => s.id != store.id).toList();
      updatedStores.add(store);
      await file.writeAsString(json.encode(updatedStores));
    } catch (e) {
      throw Exception('Failed to update store: $e');
    }
  }
}

class ListClass {
  int id;
  String nome;
  String? descricao;
  String? data;
  List<ListItem>? items = [];
  Loja? loja;
  Color? color;
  bool? detalhada = false; // False = Lista Simples, True = Lista Detalhada

  // This is the constructor
  ListClass({
    required this.id,
    required this.nome,
    this.descricao,
    this.data,
    this.loja,
    this.color,
    this.detalhada = false,
    this.items = const [],
  });

  void addItem(ListItem item) {
    if (items!.isEmpty) {
      item.id = 1;
    } else {
      item.id = items!.last.id! + 1;
    }
    items!.add(item);
  }

  void removeItem(int id) {
    items!.removeWhere((item) => item.id == id);
  }

  String setData() {
    final DateTime now = DateTime.now();
    final String formattedDate = '${now.day}/${now.month}/${now.year}';
    return formattedDate;
  }

  factory ListClass.fromJson(Map<String, dynamic> json) {
    return ListClass(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      data: json['data'],
      loja: json['loja'],
      color: json['color'] != null
          ? Color(int.parse(json['color'], radix: 16))
          : const Color.fromARGB(255, 53, 140, 255),
      detalhada: json['detalhada'],
      items: (json['items'] as List<dynamic>)
          .map((item) => ListItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'descricao': descricao,
        'data': data,
        'loja': loja,
        'color': color!.toARGB32().toRadixString(16),
        'detalhada': detalhada,
        'items': items!.map((item) => item.toJson()).toList(),
      };
}

class PartialList {
  final int id;
  final String nome;
  final String? descricao;
  final String? data;
  final Color? color;
  final bool? detalhada;

  PartialList({
    required this.id,
    required this.nome,
    this.descricao,
    this.data,
    this.color,
    this.detalhada,
  });

  factory PartialList.fromJson(Map<String, dynamic> json) {
    return PartialList(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      data: json['data'],
      color: json['color'] != null
          ? Color(int.parse(json['color'], radix: 16))
          : const Color.fromARGB(255, 53, 140, 255),
      detalhada: json['detalhada'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'descricao': descricao,
        'data': data,
        'color': color!.toARGB32().toRadixString(16),
        'detalhada': detalhada,
      };
}

//? >TODO: Arranjar o problema de não dar para abrir receitas.
//* DONE
/*
!I/flutter (16831): /data/user/0/com.devcacti.cookapp/app_flutter/testes_list_compras0_2.json
![log] Error loading lists: PathNotFoundException: Cannot open file, path = '/data/user/0/com.devcacti.cookapp/app_flutter/testes_list_compras0_2.json' (OS Error: No such file or directory, errno = 2)
*/

//List file
/* [?, !, *, TO/DO: : From the Better Comments extension]
 ? testes_list_compras01.json
 ! [log] Error loading lists: FormatException: Unexpected character (at character 138)
 !     ...ah","data":"25/12/2023","items":[]}][{"nome":"miau","descricao":"vroom",...
 !                                            ^
*/

// Final_AttemptNumber
String nTry = "0_6";

//Id file
Future<File> get _localIdFile async {
  final directory = await path_provider.getApplicationDocumentsDirectory();
  final file = File('${directory.path}/last_id_${nTry.toString()}.json');
  if (!await file.exists()) {
    await file.create();
  }
  return file;
}

//List file
Future<File> get _localFile async {
  final directory = await path_provider.getApplicationDocumentsDirectory();
  final file =
      File('${directory.path}/testes_list_compras${nTry.toString()}.json');
  if (!await file.exists()) {
    await file.create();
  }
  return file;
}

//Simple list file
Future<File> get _localSimpleFile async {
  final directory = await path_provider.getApplicationDocumentsDirectory();
  final file = File(
      '${directory.path}/testes_list_compras${nTry.toString()}_simple.json');
  if (!await file.exists()) {
    await file.create();
  }
  return file;
}

Future<int> nextId() async {
  final file = await _localIdFile;
  try {
    final contents = await file.readAsString();

    if (contents.isEmpty) {
      await file.writeAsString('1');
      return 1;
    }

    final int lastId = int.parse(contents);
    final int nextId = lastId + 1;
    return nextId;
  } catch (e) {
    return 1;
  }
}

//? Saves list in full and simple formats
Future<void> saveList(ListClass list) async {
  //Save Full List
  developer.log('Trying to save FULL list - saveList()', name: 'saveList');
  try {
    final file = await _localFile;
    List<dynamic> jsonList = [];
    try {
      final contents = await file.readAsString();
      if (contents.isNotEmpty && contents != '[]' && contents != '') {
        jsonList = json.decode(contents);
        developer.log('Contents: $contents');
      } else {
        jsonList = [];
        developer.log('Contents: $contents');
      }

      jsonList.add(list.toJson());
      developer.log(jsonList.toString());
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      developer.log('Error: $e - saveList()');
      jsonList = [];
    }

    final idFile = await _localIdFile;
    final newId = await nextId();
    await idFile.writeAsString(json.encode(newId));
  } catch (e) {
    throw Exception('Failed to save items to file: $e');
  }

  developer.log('Trying to save SIMPLE list - saveList()', name: 'saveList');
  //Save Simple List
  try {
    final file = await _localSimpleFile;
    List<dynamic> jsonList = [];
    try {
      final contents = await file.readAsString();
      jsonList = json.decode(contents);
    } catch (e) {
      jsonList = [];
    }
    jsonList.add(PartialList(
      id: list.id,
      nome: list.nome,
      descricao: list.descricao,
      data: list.data,
      color: list.color,
      detalhada: list.detalhada,
    ).toJson());
    developer.log(jsonList.toString());
    await file.writeAsString(json.encode(jsonList));
  } catch (e) {
    throw Exception('Failed to save items to file: $e');
  }
}

//? Loads all lists
Future<List<ListClass>> loadLists() async {
  try {
    developer.log('Trying to load lists - loadLists()');
    final file = await _localFile.then((value) {
      developer.log('File: $value');
    });

    if (!await file.exists()) {
      developer.log('File does not exist - loadLists()');
      return [];
    }

    developer.log('Loaded file');

    final contents = await file.readAsString();
    developer.log('Contents: $contents');

    final List<dynamic> jsonList = jsonDecode(contents);
    developer.log('Decoded file');

    final List<ListClass> lists =
        jsonList.map((json) => ListClass.fromJson(json)).toList();
    developer.log('Mapped file');

    developer.log('Lists: $lists');
    return lists;
  } catch (e) {
    developer.log('Error loading lists: $e');
    return [];
  }
}

//? Loads necessary only (id, name, description, date, color) from local simple file
Future<List<PartialList>> loadListsSimple() async {
  try {
    developer.log('Trying to load lists - loadListsSimple()');
    final file = await _localSimpleFile;

    if (!await file.exists()) {
      developer.log('File does not exist (yet) - loadListsSimple()');
      return [];
    }

    developer.log('Loaded file');

    final contents = await file.readAsString();
    developer.log('Contents: $contents');

    if (contents.isEmpty) {
      developer.log('File is empty - loadListsSimple()');
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(contents);
    developer.log('Decoded file');

    final List<PartialList> lists =
        jsonList.map((json) => PartialList.fromJson(json)).toList();
    developer.log('Mapped file');

    final List<PartialList> filteredList = lists
        .map((list) => PartialList(
              id: list.id,
              nome: list.nome,
              descricao: list.descricao,
              data: list.data,
              color: list.color,
              detalhada: list.detalhada,
            ))
        .toList();
    //developer.log('Filtered lists: ${filteredList.toList()}'); //! Useless
    return filteredList;
  } catch (e) {
    developer.log('Error loading lists: $e');
    return [];
  }
}

//? Loads lists by id for individual loading
Future<ListClass?> loadListById(int id) async {
  try {
    developer.log('Trying to load lists - loadListById()');

    final file = await _localFile;
    if (!await file.exists()) {
      developer.log('File  > ${file.path} <  DOESN\'T EXIST');
      return null;
    }

    final contents = await file.readAsString();
    developer.log('Contents: $contents');

    final List<dynamic> jsonList = jsonDecode(contents);
    developer.log('Decoded file');

    final List<ListClass> lists =
        jsonList.map((json) => ListClass.fromJson(json)).toList();
    developer.log('Mapped file');

    final filteredList = lists.firstWhere(
      (list) => list.id == id,
    );
    developer.log('Filtered list: $filteredList');

    return filteredList;
  } catch (e) {
    developer.log('Error loading lists: $e');
    return null;
  }
}

//? Deletes list by id
Future<void> deleteListById(int id) async {
  try {
    final file = await _localFile;
    final contents = await file.readAsString();
    final List<dynamic> jsonList = json.decode(contents);
    final List<ListClass> lists =
        jsonList.map((json) => ListClass.fromJson(json)).toList();
    final updatedLists = lists.where((list) => list.id != id).toList();
    await file.writeAsString(json.encode(updatedLists));
  } catch (e) {
    throw Exception('Failed to delete list: $e');
  }
  try {
    final file = await _localSimpleFile;
    final contents = await file.readAsString();
    final List<dynamic> jsonList = json.decode(contents);
    final List<PartialList> lists =
        jsonList.map((json) => PartialList.fromJson(json)).toList();
    final updatedLists = lists.where((list) => list.id != id).toList();
    await file.writeAsString(json.encode(updatedLists));
  } catch (e) {
    throw Exception('Failed to delete list: $e');
  }
}

//? Updates list by id
Future<void> updateListById(ListClass list) async {
  try {
    final file = await _localFile;
    final contents = await file.readAsString();
    final List<dynamic> jsonList = json.decode(contents);
    final List<ListClass> lists =
        jsonList.map((json) => ListClass.fromJson(json)).toList();
    final updatedLists = lists.where((l) => l.id != list.id).toList();
    updatedLists.add(list);
    await file.writeAsString(json.encode(updatedLists));
  } catch (e) {
    throw Exception('Failed to update list: $e');
  }
}

// Delete confirmation dialog
Future<bool?> deleteConfirmationDialog(
    BuildContext context, String keyWord) async {
  return await showDialog<bool?>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Apagar $keyWord'),
      content: Text('Tem a certeza que quer apagar: $keyWord?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(
            'Cancelar',
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Apagar',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
