// ignore_for_file: avoid_print

//import 'package:flutter/material.dart';

// TODO: Remake the storage system
//! Instead of using files, use a secure storage system for the user data
//! At least sensitive data should be stored in a secure way
//? https://pub.dev/packages/flutter_secure_storage
//* The cookie is important to be stored in a secure way
//* If possible storing the most ammount of user data in a secure way is the best option
//* Recipes can be stored in files, but the user data should be stored in a secure way

//* Imports
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Classes/recipes.dart';
import '../Classes/ingredients.dart';
import '../Classes/user.dart';
import '../Classes/server_info.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

// Request the image of a recipe
Future<Image?> getRecipeImage(String id,
    [Map<String, Image>? imageCache]) async {
  imageCache ??= {};

  // If the imageCache already has an image associated with the id, return that image
  if (imageCache.containsKey(id)) {
    return imageCache[id]!;
  }
  // Declaring the User object
  User user = User();
  try {
    //try to get the instance of the user
    await user.getInstance();
  } catch (e) {
    print('Error: $e');
    return Image.asset('assets/images/LittleMan.png');
  }
  var request =
      http.Request('GET', Uri.parse('$url/Recipes/RecipeImage?id=$id'));
  request.headers.addAll({'Cookie': user.cookie});

  // Prevents "null check operator used on a null value" error
  // If the imageCache is null, it will be set to an empty map

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      var bytes = await response.stream.toBytes();
      var contentType = response.headers['content-type'];

      if (contentType != null && contentType.startsWith('image/')) {
        return Image.memory(bytes);
      } else {
        print('Failed to get image: Invalid content type');
        return null;
      }
    } else {
      print(" ---> (0009) ${response.reasonPhrase}");
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

// Get all the user's recipes
Future<List<Recipe>> getMyRecipes() async {
  User? user = User();
  try {
    await user.getInstance();
  } catch (e) {
    print('Error: $e');
    return [];
  }
  // Get the user's recipes from the server
  var request = http.Request('GET', Uri.parse('$url/Recipes/GetMyRecipes'));
  request.headers.addAll({'cookie': user.cookie});

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      //print(" ---> ${await response.stream.bytesToString()}");

      // if success field is true, save the user data
      var responseBody = await response.stream.bytesToString();
      if (responseBody.contains('"error":""')) {
        print('Got recipes');

        // Parse the JSON response and return the recipes
        var json = jsonDecode(responseBody);
        var recipeinfos = json['recipes'];

        print(recipeinfos);

        // TODO: Complete this function in order to return a list of recipes
        List<Recipe> recipeList = [];
        for (var recipe in recipeinfos) {
          try {
            Recipe rcp = Recipe.fromJson(recipe);

            print('Recipe: $rcp');

            ////for (var ingredient in recipe['Ingredients']) {
            ////  var ing = Ingredient.fromJson(ingredient);
            ////  ing.save();
            ////}

            recipeList.add(rcp);
          } catch (e) {
            print('Error: $e');
          }
        }

        return recipeList;
      } else {
        print('Failed to get recipes');
        print('Response: $responseBody');
        return [];
      }
    } else {
      print(" ---> (0011) ${response.reasonPhrase}");
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

// Get all the recipes that are within the searched parameters
Future<List<Recipe>> getSearchRecipes(String search, int type) async {
  User? user = User();
  try {
    await user.getInstance();
  } catch (e) {
    print('Error: $e');
    return [];
  }
  // Get the user's recipes from the server
  var request = http.Request('GET', Uri.parse('$url/Recipes/Search'));
  request.headers.addAll({'cookie': user.cookie});
  request.bodyFields = {'search': search, 'type': type.toString()};

  List<Recipe> recipeList = [];

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      //print(" ---> ${await response.stream.bytesToString()}");

      // if success field is true, save the user data
      var responseBody = await response.stream.bytesToString();
      if (responseBody.contains('"error":""')) {
        print('Got recipes');

        // Parse the JSON response and return the recipes
        var json = jsonDecode(responseBody);
        var recipeinfos = json['recipes'];

        for (var recipe in recipeinfos) {
          try {
            // Creates a temporary recipe object
            Recipe rcp = Recipe.fromJson(recipe);

            print('Recipe: $rcp');

            //! For now it won't save the ingredients, it will load them every time
            //for (var ingredient in recipe['Ingredients']) {
            //  var ing = Ingredient.fromJson(ingredient);
            //  ing.save();
            //}

            // Adds the recipe object to the list
            recipeList.add(rcp);
          } catch (e) {
            print('Error: $e');
          }
        }
        // Prints the information about the recipes on the console for debugging
        print(recipeinfos);

        // Returns the list of recipes
        return recipeList;
      }
    } else {
      print(" ---> (0012) ${response.reasonPhrase}");
      return List<Recipe>.empty();
    }
  } catch (e) {
    print('Error: $e');
  }
  return List<Recipe>.empty();
}

// Gets the 10 most popular recipes
//? [int page = 0] -> Is a optional parameter, if nothing is set, it will ask for the first page
//? Every page has 10 recipes and starts at 10 * page
//? In programming, 0 is generally the first page
//? However, in terms of user interface, 1 is the first page and the page would start at 10 * page + 1
Future<List<Recipe>> getPopularRecipes([int page = 0]) async {
  User? user = User();
  try {
    await user.getInstance();
  } catch (e) {
    print('Error: $e');
    return [];
  }
  // Get the user's recipes from the server
  var request = http.Request('GET', Uri.parse('$url/Recipes/GetPopular'));
  request.headers.addAll({'cookie': user.cookie});
  request.bodyFields = {'page': page.toString()};

  List<Recipe> recipeList = [];

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      //print(" ---> ${await response.stream.bytesToString()}");

      // if success field is true, save the user data
      var responseBody = await response.stream.bytesToString();
      if (responseBody.contains('"error":""')) {
        print('Got popular recipes');

        // Parse the JSON response and return the recipes
        var json = jsonDecode(responseBody);
        var recipeinfos = json['recipes'];

        ////print(recipeinfos);
        for (var recipe in recipeinfos) {
          try {
            // Creates a temporary recipe object
            Recipe rcp = Recipe.fromJson(recipe);
            // Adds the recipe object to the list
            recipeList.add(rcp);
          } catch (e) {
            //? This try catch is indeed inside another try catch block but it's for better error handling
            print('Error: $e');
          }
        }

        // Returns the list of recipes
        return recipeList;
      }
    } else {
      print(" ---> (0013) ${response.reasonPhrase}");
      return List<Recipe>.empty();
    }
  } catch (e) {
    print('Error: $e');
  }
  return List<Recipe>.empty();
}

// Other functions
// Gets the ingredients of a recipe from within the app's files and, if it fails, from the server as well
Future<List<Ingredient>> fetchIngredients(String id) async {
  // Check if there is a file with the recipe id
  var file = File('recipes/$id.json');

  if (!Directory("recipes").existsSync()) {
    Directory("recipes").createSync();
  }

  // Check if the file exists and check if the directory exists
  if (file.existsSync()) {
    try {
      // Read the contents
      var json = file.readAsStringSync();

      // Parse the JSON response and return the recipe
      var decodedJson = jsonDecode(json);

      // Read, the part of the JSON that contains the ingredients
      var ingredients = decodedJson['Ingredients'];

      // The part that contains the ids only contains a small ammount of data, meaning we can't convert it into a list of ingredients
      // Therefore, we need to get the ids from that file so that we can get the ingredients from the recipes/ingredients directory
      List<String> ingredientIds = [];

      for (var ingredient in ingredients) {
        try {
          ingredientIds.add(ingredient['IngGUID']);
        } catch (e) {
          print('Error: $e');
        }
      }

      List<Ingredient> ingredientList = [];

      for (var ingredientId in ingredientIds) {
        try {
          var ingredientFile = File('recipes/ingredients/$ingredientId.json');
          var ingredientJson = ingredientFile.readAsStringSync();
          var ingredientDecodedJson = jsonDecode(ingredientJson);

          ingredientList.add(Ingredient.fromJson(ingredientDecodedJson));
        } catch (e) {
          print('Error: $e');
        }
      }

      return ingredientList;
    } catch (e) {
      print('Error fetching the ingredient $id: $e');
      return [Ingredient(id: id, name: 'Ingredient', unit: 'Unit')];
    }
  } else {
    User? user = User();
    try {
      await user.getInstance();
    } catch (e) {
      print('Error: $e');
      return [];
    }
    // Fetch the recipe from the server
    ////~TODO: Server is refusing to allow the request, always returning 404 (Not Found)
    var request = http.Request(
        'GET', Uri.parse('$url/Recipes/GetIngredientsByRecipe?Id=$id'));
    request.headers.addAll({'cookie': user.cookie});

    print("Cookie: ${user.cookie}");

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        //print(" ---> ${await response.stream.bytesToString()}");

        // if success field is true, save the user data
        var responseBody = await response.stream.bytesToString();
        if (responseBody.contains('"error":""')) {
          print('Got ingredient');

          // Parse the JSON response and return the recipe
          var json = jsonDecode(responseBody);

          // The ingredients returned by the server are in a list
          // The list is then mapped to a list of Ingredient objects
          var ingredients = json['ingredients'];

          List<Ingredient> ingredientList =
              List<Ingredient>.empty(growable: true);

          for (var ingredient in ingredients) {
            try {
              Ingredient ing = Ingredient.fromJson(ingredient);
              ing.save();
              ingredientList.add(ing);
            } catch (e) {
              print('Error: $e');
            }
          }

          //TODO: This makes 0 sense, we are already saving each individual ingredient
          //// Save the recipe to the application files
          //file.writeAsStringSync(jsonEncode(ingredients));

          return ingredientList;
        } else {
          print('Failed to get ingredient');
          print('Response: $responseBody');
          return [Ingredient(id: id, name: 'Ingredient Fail 1', unit: 'Unit')];
        }
      } else {
        // If the status code is anything but 200, return a default recipe
        print(" ---> (0017) ${response.reasonPhrase}");
        return [Ingredient(id: id, name: 'Ingredient Fail 2', unit: 'Unit')];
      }
    } catch (e) {
      print('Error: $e');
      return [Ingredient(id: id, name: 'Ingredient Fail 3', unit: 'Unit')];
    }
  }
}

// Fetches the ingredients of a specific recipe with the id of the recipe, only from the server
Future<List<Ingredient>> recipeIngredients(String id) async {
  User? user = User();
  try {
    await user.getInstance();
  } catch (e) {
    print('Error: $e');
    return [];
  }
  // localhost:44322/Recipes/GetIngredientsByRecipe?Id=630fd198-beba-4f57-944d-8eb7907d8f65
  // This one is only online, doesn't check the local files
  var request = http.Request(
      'GET', Uri.parse('$url/Recipes/GetIngredientsByRecipe?Id=$id'));
  request.headers.addAll({'cookie': user.cookie});

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      //print(" ---> ${await response.stream.bytesToString()}");

      // if success field is true, save the user data
      var responseBody = await response.stream.bytesToString();
      if (responseBody.contains('"error":""')) {
        print('Got ingredient');

        // Parse the JSON response and return the recipe
        var json = jsonDecode(responseBody);

        // The ingredients returned by the server are in a list
        // The list is then mapped to a list of Ingredient objects
        var ingredients = json['Ingredients'];

        if (ingredients == null) {
          return [Ingredient(id: id, name: 'Ingredient Fail 4', unit: 'Unit')];
        }

        List<Ingredient> ingredientList =
            List<Ingredient>.empty(growable: true);

        for (var ingredient in ingredients) {
          try {
            Ingredient ing = Ingredient.fromJson(ingredient);
            //!ing.save();
            ingredientList.add(ing);
          } catch (e) {
            print('Error: $e');
          }
        }

        return ingredientList;
      } else {
        print('Failed to get ingredient');
        print('Response: $responseBody');
        return [Ingredient(id: id, name: 'Ingredient Fail 1', unit: 'Unit')];
      }
    } else {
      // If the status code is anything but 200, return a default recipe
      print(" ---> (0018) ${response.reasonPhrase}");
      return [Ingredient(id: id, name: 'Ingredient Fail 2', unit: 'Unit')];
    }
  } catch (e) {
    print('Error: $e');
    return [Ingredient(id: id, name: 'Ingredient Fail 3', unit: 'Unit')];
  }
}

// Fetch number of pages of the popular recipes
Future<int> fetchPopularPages() async {
  User? user = User();
  try {
    await user.getInstance();
  } catch (e) {
    print('Error: $e');
    return 0;
  }
  // Get the user's recipes from the server
  var request = http.Request('GET', Uri.parse('$url/Recipes/GetPopularPages'));
  request.headers.addAll({'cookie': user.cookie});

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      //print(" ---> ${await response.stream.bytesToString()}");

      // if success field is true, save the user data
      var responseBody = await response.stream.bytesToString();
      if (responseBody.contains('"error":""')) {
        // Parse the JSON response and return the number of pages
        var json = jsonDecode(responseBody);
        var totalPages = json['totalPages'];

        return totalPages;
      } else {
        print('Failed to get pages');
        print('Response: $responseBody');
        return 0;
      }
    } else {
      print(" ---> (0019) ${response.reasonPhrase}");
      return 0;
    }
  } catch (e) {
    print('Error: $e');
    return 0;
  }
}

// Sends a list of ingredients to put in the server's database
Future<List<String>> newIngredients(List<Ingredient> ings) async {
  User? user = User();
  try {
    await user.getInstance();
  } catch (e) {
    print('Error: $e');
    return [];
  }
  // Upload the ingredients to the server: /Recipes/NewIngredients
  try {
    if (ings.isEmpty) {
      return List<String>.empty();
    }
    var request =
        http.MultipartRequest('PUT', Uri.parse('$url/Recipes/NewIngredients'));
    request.headers.addAll({'cookie': user.cookie});
    // We need to put the ingredients in the body, each name is in the the form of "name": "value1;value2;value3"
    // The values are separated by a semicolon in the same field, meaning that if the user puts semicolons, the program deletes them

    List<String> names = [];
    List<String> units = [];

    for (var ing in ings) {
      Ingredient cing = ing; // Current ingredient
      // Curating the inputs
      // Replacing semicolons with commas
      cing.name =
          cing.name.replaceAll(';', ','); // In case the user puts a semicolon
      // Replacing semicolons with commas
      cing.unit =
          cing.unit.replaceAll(';', ','); // In case the user puts a semicolon

      // Inserting the values into the lists
      names.add(cing.name);
      units.add(cing.unit);
    }

    // Joining the lists into strings, separated by semicolons
    final namesString = names.join(';');
    final unitsString = units.join(';');

    // Add the ingredients to the body
    request.fields.addAll({'names': namesString, 'units': unitsString});

    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
      // if success field is true, save the user data
      var responseBody = await response.stream.bytesToString();
      if (responseBody.contains('"error":""')) {
        print('New ingredients added');

        // Parse the JSON response and return the recipes
        var json = jsonDecode(responseBody);
        var ingredientIds = json['ingredientIds'];
        print(json);

        // Return the ingredient ids in a list
        return ingredientIds.cast<String>();
      } else {
        print('Failed to add ingredients');
        print('Response: $responseBody');
        return List<String>.empty();
      }
    } else {
      print(" ---> (0020) ${response.reasonPhrase}");
      return List<String>.empty();
    }
  } catch (e) {
    print('Error: $e');
  }

  return List<String>.empty(); //? Not implemented
}
