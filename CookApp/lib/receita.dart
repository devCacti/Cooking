import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;

class Recipe {
  final int id;
  final String? foto;
  final String nome;
  final String descricao;
  final String ingredientes;
  final String procedimento;
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
      ingredientes: json['ingredientes'],
      procedimento: json['procedimento'],
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
    //* Caso a receita não exista ou tenha ocorrido algum erro, vai retornar uma lista vazia.
    return [];
  }
}

Future<void> saveRecipe(Recipe recipe) async {
  try {
    final file = await _localFile;
    List<dynamic> jsonList = [];
    //* Lê os elementos do ficheiro, caso exista.
    try {
      final contents = await file.readAsString();
      jsonList = json.decode(contents);
    } catch (e) {
      //* Caso o ficheiro não exista, cria uma lista vazia.
      jsonList = [];
    }
    // Adiciona a nova lista ao fim da lista correspondente ao que o ficheiro contém.
    jsonList.add(recipe.toJson());
    // Escreve a versão atualizada do ficheiro com a nova receita para o ficheiro.
    await file.writeAsString(json.encode(jsonList));
  } catch (e) {
    // Caso ocorra um erro, lança uma exceção.
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
