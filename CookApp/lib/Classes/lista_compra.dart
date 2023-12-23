import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;

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

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome, 'descricao': descricao, 'done': done};
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
    final List<LstItem> items = jsonList.map((json) => LstItem.fromJson(json)).toList();
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
    final List<LstItem> items = jsonList.map((json) => LstItem.fromJson(json)).toList();
    final updatedItems = items.where((item) => item.id != id).toList();
    await file.writeAsString(json.encode(updatedItems));
  } catch (e) {
    throw Exception('Failed to delete item: $e');
  }
}
