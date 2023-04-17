import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;

class Recipe {
  final int id;
  final String name;
  final String description;
  final String ingredients;
  final String procedure;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.procedure,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      ingredients: json['ingredients'],
      procedure: json['procedure'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'ingredients': ingredients,
        'procedure': procedure,
      };
}

Future<File> get _localFile async {
  final directory = await path_provider.getApplicationDocumentsDirectory();
  return File('${directory.path}/testes_receitas.json');
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
    //* If the file doesn't exist or an error occurs while reading the file, return an empty list of recipes.
    return [];
  }
}

Future<void> saveRecipe(Recipe recipe) async {
  try {
    final file = await _localFile;
    List<dynamic> jsonList = [];
    //* Read the existing contents of the file, if it exists.
    try {
      final contents = await file.readAsString();
      jsonList = json.decode(contents);
    } catch (e) {
      //* If the file doesn't exist, create an empty list.
      jsonList = [];
    }
    // Append the new recipe to the end of the array.
    jsonList.add(recipe.toJson());
    // Write the updated array back to the file.
    await file.writeAsString(json.encode(jsonList));
  } catch (e) {
    // If an error occurs, throw an exception.
    throw Exception('Failed to save recipe: $e');
  }
}

Future<File> get _localIdFile async {
  final directory = await path_provider.getApplicationDocumentsDirectory();
  return File('${directory.path}/last_recipe_id.txt');
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
    // If the file doesn't exist or an error occurs while reading the file,
    // create a new file with id 1 and return it.
    await file.writeAsString('1');
    return 1;
  }
}
