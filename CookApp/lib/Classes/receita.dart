import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;

class Recipe {
  final int id;
  final String? foto;
  final String nome;
  final String descricao;
  final List<String>? ingredientes;
  final List<String>? ingTipo;
  final List<double>? ingQuant;
  final List<String>? procedimento;
  final double tempo;
  final double porcoes;
  final String categoria;
  final bool favorita;

  Recipe({
    required this.id,
    this.foto,
    required this.nome,
    required this.descricao,
    required this.ingredientes,
    required this.ingTipo,
    required this.ingQuant,
    required this.procedimento,
    required this.tempo,
    required this.porcoes,
    required this.categoria,
    required this.favorita,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      foto: json['foto'],
      nome: json['nome'],
      descricao: json['descricao'],
      ingredientes: json['ingredientes'] != null
          ? List<String>.from(json['ingredientes'])
          : null,
      ingTipo:
          json['ingTipo'] != null ? List<String>.from(json['ingTipo']) : null,
      ingQuant:
          json['ingQuant'] != null ? List<double>.from(json['ingQuant']) : null,
      procedimento: json['procedimento'] != null
          ? List<String>.from(json['procedimento'])
          : null,
      tempo: json['tempo'],
      porcoes: json['porcoes'],
      categoria: json['categoria'],
      favorita: json['favorita'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'foto': foto,
        'nome': nome,
        'descricao': descricao,
        'ingredientes': ingredientes,
        'ingTipo': ingTipo,
        'ingQuant': ingQuant,
        'procedimento': procedimento,
        'tempo': tempo,
        'porcoes': porcoes,
        'categoria': categoria,
        'favorita': favorita,
      };
}

Future<File> get _localFile async {
  final directory = await path_provider.getApplicationDocumentsDirectory();
  return File('${directory.path}/testes_num5_receitas.json');
}

Future<List<Recipe>> loadRecipes() async {
  try {
    final file = await _localFile;
    final contents = await file.readAsString();
    final List<dynamic> jsonList = json.decode(contents);
    final List<Recipe> recipes =
        jsonList.map((json) => Recipe.fromJson(json)).toList();
    return recipes;
  } catch (e) {
    // Caso a receita não exista ou tenha ocorrido algum erro, vai retornar uma lista vazia.
    return [];
  }
}

Future<void> saveRecipe(Recipe recipe) async {
  try {
    final file = await _localFile;
    List<dynamic> jsonList = [];
    try {
      final contents = await file.readAsString();
      jsonList = json.decode(contents);
    } catch (e) {
      jsonList = [];
    }
    jsonList.add(recipe.toJson());
    await file.writeAsString(json.encode(jsonList));
  } catch (e) {
    throw Exception('Failed to save recipe: $e');
  }
}

Future<File> get _localIdFile async {
  final directory = await path_provider.getApplicationDocumentsDirectory();
  return File('${directory.path}/last_recipe_id_test_5.txt');
}

Future<int> getNextId() async {
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

Future<void> deleteRecipeById(int id) async {
  try {
    final file = await _localFile;
    final contents = await file.readAsString();
    final List<dynamic> jsonList = json.decode(contents);
    final List<Recipe> recipes =
        jsonList.map((json) => Recipe.fromJson(json)).toList();
    final updatedRecipes = recipes.where((recipe) => recipe.id != id).toList();
    await file.writeAsString(json.encode(updatedRecipes));
  } catch (e) {
    throw Exception('Failed to delete recipe: $e');
  }
}

Future<void> editRecipeById(int id, Recipe newRecipe) async {
  try {
    final file = await _localFile;
    final contents = await file.readAsString();
    final List<dynamic> jsonList = json.decode(contents);
    final List<Recipe> recipes =
        jsonList.map((json) => Recipe.fromJson(json)).toList();
    final index = recipes.indexWhere((recipe) => recipe.id == id);
    if (index == -1) {
      throw Exception('Recipe with id $id not found');
    }
    final updatedRecipes = List<Recipe>.from(recipes);
    updatedRecipes[index] = Recipe(
      id: id,
      foto: newRecipe.foto,
      nome: newRecipe.nome,
      descricao: newRecipe.descricao,
      ingredientes: newRecipe.ingredientes,
      ingQuant: newRecipe.ingQuant,
      ingTipo: newRecipe.ingTipo,
      procedimento: newRecipe.procedimento,
      tempo: newRecipe.tempo,
      porcoes: newRecipe.porcoes,
      categoria: newRecipe.categoria,
      favorita: newRecipe.favorita,
    );
    await file.writeAsString(json.encode(updatedRecipes));
  } catch (e) {
    throw Exception('Failed to edit recipe: $e');
  }
}
