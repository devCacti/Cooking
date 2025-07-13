// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:cookapp/Classes/Shopping/list_item.dart';
import 'package:cookapp/Classes/Shopping/list_store.dart';
import 'package:flutter/material.dart';

class ShoppingList {
  String Id = UniqueKey().toString();
  String Name;
  String? Description;
  List<ListItem> ListItems = [];
  ListStore? Store;
  Color? ListColor;
  bool Detailed = false;
  DateTime? CreatedAt = DateTime.now();
  DateTime? UpdatedAt = DateTime.now();

  static File file = File("ShoppingLists.json");

  ShoppingList({
    required this.Id,
    required this.Name,
    this.Description,
    required this.ListItems,
    this.Store,
    this.Detailed = false,
    this.ListColor,
    this.CreatedAt,
    this.UpdatedAt,
  });

  // Deserialization from JSON
  ShoppingList.fromJson(Map<String, dynamic> json)
      : Id = json['Id'] as String,
        Name = json['Name'] as String,
        Description = json['Description'] as String?,
        ListItems = (json['ListItems'] as List).map((item) => ListItem.fromJson(item)).toList(),
        Store = json['Store'] != null ? ListStore.fromJson(json['Store']) : null,
        ListColor = json['Color'] != null ? Color(json['Color']) : null,
        Detailed = json['Detailed'] ?? false,
        CreatedAt = json['CreatedAt'] != null ? DateTime.parse(json['CreatedAt']) : DateTime.now(),
        UpdatedAt = json['UpdatedAt'] != null ? DateTime.parse(json['UpdatedAt']) : DateTime.now();

  // Serialization to JSON
  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'Name': Name,
      'Description': Description,
      'ListItems': ListItems.map((item) => item.toJson()).toList(),
      'Store': Store?.toJson(),
      'Detailed': Detailed,
      'Color': ListColor?.toARGB32(),
      'CreatedAt': CreatedAt?.toIso8601String(),
      'UpdatedAt': UpdatedAt?.toIso8601String(),
    };
  }

  void addItem(ListItem item) {
    ListItems.add(item);
    UpdatedAt = DateTime.now();
  }

  static Future<List<ShoppingList>> loadLists() async {
    if (!await file.exists()) {
      return [];
    }
    String content = await file.readAsString();
    List<dynamic> jsonData = jsonDecode(content);
    return jsonData.map((item) => ShoppingList.fromJson(item)).toList();
  }

  static Future<void> saveLists(List<ShoppingList> lists) async {
    String jsonString = jsonEncode(lists.map((list) => list.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  static Future<void> addList(ShoppingList list) async {
    List<ShoppingList> lists = await loadLists();
    lists.add(list);
    await saveLists(lists);
  }

  static Future<void> removeList(String ID) async {
    List<ShoppingList> lists = await loadLists();
    lists.removeWhere((l) => l.Id == ID);
    await saveLists(lists);
  }

  static Future<void> clearAllLists() async {
    await file.writeAsString(jsonEncode([]));
  }

  static Future<void> updateList(String ID, ShoppingList newList) async {
    List<ShoppingList> lists = await loadLists();
    int index = lists.indexWhere((list) => list.Id == ID);
    if (index != -1) {
      lists[index] = newList;
      await saveLists(lists);
    }
  }
}
