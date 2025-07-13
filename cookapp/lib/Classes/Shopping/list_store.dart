// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

class ListStore {
  String Name;
  bool isExpanded = true;

  static File file = File("ListStores.json");

  ListStore({
    required this.Name,
    this.isExpanded = true,
  });

  // Deserialization from JSON
  ListStore.fromJson(Map<String, dynamic> json) : Name = json['Name'] as String;

  // Serialization to JSON
  Map<String, dynamic> toJson() {
    return {
      'Name': Name,
    };
  }

  static Future<List<ListStore>> load() async {
    if (!await file.exists()) {
      return [];
    }
    String jsonString = await file.readAsString();
    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => ListStore.fromJson(json)).toList();
  }

  static Future<void> save(List<ListStore> stores) async {
    List<Map<String, dynamic>> jsonList = stores.map((store) => store.toJson()).toList();
    String jsonString = json.encode(jsonList);
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    await file.writeAsString(jsonString);
  }

  static Future<void> addStore(ListStore store) async {
    List<ListStore> stores = await load();
    stores.add(store);
    await save(stores);
  }
}
