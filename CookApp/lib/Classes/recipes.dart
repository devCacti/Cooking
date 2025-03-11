import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'ingredients.dart';
import 'server_info.dart';
import 'user.dart';

class Recipe {
  String id;
  File? image;
  String title;
  String description;
  List<IngBridge>? bridges = [];
  List<Ingredient>? ingredients = [];
  List<String>? steps = [];
  double time = 0.0;
  double servings = 0.0;
  int type = 0;
  bool isAllowed = false;
  bool isPublic = false;
  String author = '';
  int likes = 0;

  Recipe({
    required this.id,
    this.image,
    required this.title,
    required this.description,
    this.bridges,
    this.ingredients,
    this.steps,
    this.time = 0.0,
    this.servings = 0.0,
    this.type = 0,
    this.isAllowed = false,
    this.isPublic = false,
    this.author = '',
    required this.likes,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['GUID'],
      //image: json['image'],
      title: json['Title'],
      description: json['Description'] ?? '',
      bridges: (json['Ingredients'] is List)
          ? (json['Ingredients'] as List<dynamic>?)
              ?.map<IngBridge>((bridge) => IngBridge.fromJson(bridge))
              .toList()
          : [IngBridge.fromJson(json['Ingredients'])],
      steps: (json['Steps'] is List)
          ? (json['Steps'] as List<dynamic>?)
              ?.map<String>((step) =>
                  (step as Map<String, dynamic>)['Details'].toString())
              .toList()
          : [json['Steps'].toString()],
      time: (json['Time'] is int)
          ? (json['Time'] as int).toDouble()
          : (json['Time'] ?? 0.0) as double,
      servings: (json['Portions'] is int)
          ? (json['Portions'] as int).toDouble()
          : (json['Portions'] ?? 0.0) as double,
      type: (json['Type'] is int)
          ? json['Type']
          : (json['Type'] as double).toInt(),
      //isAllowed: json['isAllowed'],
      isPublic: json['isPublic'] ?? false,
      author: json['Author'] ?? '',
      likes: json['NumLikes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'description': description,
      'bridges': bridges,
      'steps': steps,
      'time': time,
      'servings': servings,
      'type': type,
      'isAllowed': isAllowed,
      'isPublic': isPublic,
    };
  }

  bool saveAsNew() {
    // save the recipe to the application files
    String name = 'myrecipe$id.json';

    var file = File(name);
    if (file.existsSync()) {
      return false;
    }

    file.writeAsStringSync(jsonEncode(this));

    return true;
  }

  void setImage(File image) {
    this.image = image;

    saveImage();
  }

  void addBridge(IngBridge bridge) {
    bridges?.add(bridge);
  }

  void removeBridge(IngBridge bridge) {
    if (bridges == null) {
      return;
    }
    bridges?.remove(bridge);
  }

  //void addStep(String step) {
  //  steps.add(step);
  //}

  //void removeStep(String step) {
  //  steps.remove(step);
  //}

  String getType() {
    switch (type) {
      case 1:
        return 'Bolos';
      case 2:
        return 'Tartes';
      case 3:
        return 'Sobremesas';
      case 4:
        return 'Pratos';
      default:
        return 'Geral';
    }
  }

  void saveImage() {
    if (image == null) {
      return;
    }

    // Save the image to the application files
    String name = '${id}main.jpg';

    var file = File(name);
    file.writeAsBytesSync(image!.readAsBytesSync());
  }

  Future<void> loadImage() async {
    // Load the image from the application files
    String name = '${id}main.jpg';

    var file = File(name);
    if (!file.existsSync()) {
      // If the file does not exist, get the image from the server
      // request to /Recipes/RecipeImage
      // The image is received as an actual image file, not a string
      // To receive it, a id needs to be sent in the arguments
      // Example: $url/Recipes/RecipeImage?id=630fd198-beba-4f57-944d-8eb7907d8f65
      var request =
          http.Request('GET', Uri.parse('$url/Recipes/RecipeImage?id=$id'));

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          //print(" ---> ${await response.stream.bytesToString()}");

          // if success field is true, save the user data
          var responseBody = await response.stream.bytesToString();
          if (responseBody.contains('"error":""')) {
            print('Got image');

            // Save the image to the application files
            file.writeAsBytesSync(responseBody.codeUnits);
          } else {
            print('Failed to get image');
            print('Response: $responseBody');
            return;
          }
        } else {
          print(" ---> (0006) ${response.reasonPhrase}");
          return;
        }
      } catch (e) {
        print('Error: $e');
        return;
      }

      image = file;
    }
  }

  factory Recipe.defaultR() {
    return Recipe(
      id: '',
      title: 'Recipe',
      description: 'Description',
      steps: [],
      time: 0.0,
      servings: 0.0,
      type: 0,
      isPublic: false,
      author: '',
      likes: 0,
    );
  }
}

// RecipeC represents the real recipe class that the server uses, it has no required fields except for the title
// This class is ONLY used to send information to the server, not to receive it, that one is the 'Recipe' class
class RecipeC {
  File? image;
  String title;
  String? description;
  List<Map<String, String>>?
      customIngM; // Custom ingredient measurement(s) id:amount;id:amount;
  List<double>? ingramounts; // ing1Ammout;ing2Amount;ing3Amount;...
  List<String>? steps;
  double time = 0;
  double portions = 0;
  int type = 0;
  bool isPublic = false;
  List<String>? ingredientIds = [];

  RecipeC({
    this.image,
    required this.title, //THIS IS COMPLETELY REQUIRED
    this.description,
    this.customIngM,
    this.ingramounts,
    this.steps,
    this.time = 0,
    this.portions = 0,
    this.type = 0,
    this.isPublic = false,
    this.ingredientIds,
  });

  factory RecipeC.defaultR() {
    return RecipeC(title: 'Empty');
  }

  void setBridges(List<IngBridge> bridges) {
    customIngM = [];
    ingramounts = [];
    ingredientIds = [];

    for (var bridge in bridges) {
      customIngM!.add({bridge.ingredient: bridge.amount.toString()});
      ingramounts!.add(bridge.amount);
      ingredientIds!.add(bridge.ingredient);
    }
  }

  // Function for sending the recipe to the server at /Recipes/NewRecipe
  Future<bool> send() async {
    User? user = User();
    try {
      await user.getInstance();
    } catch (e) {
      print('Error: $e');
      return false;
    }

    // The recipe creation follows a specific structure to ensure compatibility with the server
    var request =
        http.MultipartRequest('PUT', Uri.parse('$url/Recipes/NewRecipe'));
    request.headers.addAll({'cookie': user.cookie});

    //* Create the strings for: customIngM, ingramounts, steps, ingredientIds
    //* The steps string is a type of JSON string that only contains a "steps" field and inside of it, each step is inside a "details" field
    //* The ingredientIds string is a list of ingredient ids separated by a semicolon
    //* The customIngM string is a list of custom ingredient measurements separated by a semicolon however:
    //* The format of the above ^^^^ is like this: id1:amount1;id2:amount2;id3:amount3; and so on

    try {
      //? ----------- IngredientIds string --------------------
      String ingredientIds = '';
      for (var id in this.ingredientIds ?? []) {
        ingredientIds += '$id;';
      }
      // Remove the last semicolon
      if (ingredientIds.isNotEmpty) {
        ingredientIds = ingredientIds.substring(0, ingredientIds.length - 1);
      }

      //? ----------- IngrAmounts string ----------------------
      String ingramounts = '';
      for (var amount in this.ingramounts ?? []) {
        ingramounts += '$amount;';
      }
      if (ingramounts.isNotEmpty) {
        // Remove the last semicolon
        ingramounts = ingramounts.substring(0, ingramounts.length - 1);
        // Replace any dots with commas -> Standardize the format | The server expects commas | 0.5 -> 0,5
        ingramounts = ingramounts.replaceAll(',', '.');
      }

      //? ----------- Steps string ----------------------------
      String steps = '[';
      if (this.steps == null || this.steps!.isEmpty) {
        steps = '[]';
      } else {
        for (var step in this.steps ?? []) {
          steps += '{"details":"$step"},';
        }
        // Remove the last comma and add the closing bracket
        steps = '${steps.substring(0, steps.lastIndexOf(','))}]';
      }

      //? ----------- CustomIngM string -----------------------
      String customIngM = '';
      for (var ing in this.customIngM ?? []) {
        customIngM += '${ing[0]}:${ing[1]};';
        print('Ing: ${ing[0]}:${ing[1]}');
      }
      if (customIngM.isNotEmpty) {
        // Remove the last semicolon
        customIngM = customIngM.substring(0, customIngM.length - 1);
      }

      //? ----------- Add the image to the request ------------
      if (image != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          image!.readAsBytesSync(),
          filename: 'image.png',
        ));
      }

      //? Debugging prints
      print("Steps: $steps");

      // Add the fields to the request | All the names of the atributes of the class match the body field names
      request.fields.addAll({
        'title': title,
        'description': description ?? '',
        'customIngM': customIngM,
        'ingramounts': ingramounts,
        'time': time.toString().replaceAll(',', '.'),
        'portions': portions.toString().replaceAll(',', '.'),
        'steps': steps,
        //!'type': type.toString(), //TODO: Make this ERROR PROOF
        'isPublic': isPublic
            .toString(), // If isPublic is true, it will send a value of 'true' telling the server that the recipe is public
        'ingredientIds': ingredientIds,
      });
      print(request.fields);
    } catch (e) {
      print('Error: $e');
      return false;
    }

    // Send the request
    try {
      print(request);
      var response = await request.send();
      if (response.statusCode == 200) {
        // if success field is true, save the user data
        var responseBody = await response.stream.bytesToString();
        if (responseBody.contains('"error":""')) {
          print('Recipe sent successfully');

          // Parse the JSON response and return the recipe
          var json = jsonDecode(responseBody);

          print(json);

          return true;
        } else {
          print('Failed to send recipe');
          print('Response: $responseBody');
          return false;
        }
      } else {
        print(" ---> (0007) ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Function for sending a updated version of a recipe, this time, it needs the GUID of the recipe
  Future<bool> update(String GUID) async {
    User? user = User();
    try {
      await user.getInstance();
    } catch (e) {
      print('Error: $e');
      return false;
    }

    // The recipe update follows a specific structure to ensure compatibility with the server
    // That compatibility is very similar to the one used to send a brand new recipe, the only
    //difference is that this one includes a GUID to tell the server which recipe to update

    var request =
        http.MultipartRequest('PUT', Uri.parse('$url/Recipes/UpdateRecipe'));

    // Set the cookie, this lets the server know which user is making the request
    request.headers.addAll({'cookie': user.cookie});

    //* Create the strings for: customIngM, ingramounts, steps, ingredientIds

    try {
      //? ----------- IngredientIds string --------------------
      String ingredientIds = '';
      for (var id in this.ingredientIds ?? []) {
        ingredientIds += '$id;';
      }
      // Remove the last semicolon
      if (ingredientIds.isNotEmpty) {
        ingredientIds = ingredientIds.substring(0, ingredientIds.length - 1);
      }

      //? ----------- IngrAmounts string ----------------------
      String ingramounts = '';
      for (var amount in this.ingramounts ?? []) {
        ingramounts += '$amount;';
      }
      if (ingramounts.isNotEmpty) {
        // Remove the last semicolon
        ingramounts = ingramounts.substring(0, ingramounts.length - 1);
        // Replace any dots with commas -> Standardize the format | The server expects commas | 0.5 -> 0,5
        ingramounts = ingramounts.replaceAll(',', '.');
      }

      //? ----------- Steps string ----------------------------
      String steps = '[';
      if (this.steps == null || this.steps!.isEmpty) {
        steps = '[]';
      } else {
        for (var step in this.steps ?? []) {
          steps += '{"details":"$step"},';
        }
        // Remove the last comma and add the closing bracket
        steps = '${steps.substring(0, steps.lastIndexOf(','))}]';
      }

      //? ----------- CustomIngM string -----------------------
      String customIngM = '';
      for (var ing in this.customIngM ?? []) {
        customIngM += '${ing['IngGUID']}:${ing['CustomUnit']};';
        print('Ing: ${ing['IngGUID']}:${ing['CustomUnit']}');
      }
      if (customIngM.isNotEmpty) {
        // Remove the last semicolon
        customIngM = customIngM.substring(0, customIngM.length - 1);
      }

      //? ----------- Add the image to the request ------------
      if (image != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          image!.readAsBytesSync(),
          filename: 'image.png',
        ));
      }

      //? Debugging prints
      print("Steps: $steps");

      // Add the fields to the request | All the names of the atributes of the class match the body field names
      request.fields.addAll({
        'GUID': GUID,
        'title': title,
        'description': description ?? '',
        'customIngM': customIngM,
        'ingramounts': ingramounts,
        'time': time.toString().replaceAll(',', '.'),
        'portions': portions.toString().replaceAll(',', '.'),
        'steps': steps,
        //!'type': type.toString(), //TODO: Make this not give an error
        'isPublic': isPublic.toString(), // True for now
        'ingredientIds': ingredientIds,
      });

      print(request.fields);

      // Send the request
      var response = await request.send();
      if (response.statusCode == 200) {
        // if success field is true, save the user data
        var responseBody = await response.stream.bytesToString();
        if (responseBody.contains('"error":""')) {
          print('Recipe updated successfully');

          // Parse the JSON response and return the recipe
          var json = jsonDecode(responseBody);

          print(json);

          return true;
        } else {
          print('Failed to update recipe');
          print('Response: $responseBody');
          return false;
        }
      } else {
        print(" ---> (0008) ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
