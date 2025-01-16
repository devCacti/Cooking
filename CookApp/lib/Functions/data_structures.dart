// ignore_for_file: avoid_print

//import 'package:flutter/material.dart';

// TODO: Remake the storage system
//! Instead of using files, use a secure storage system
//! At least sensitive data should be stored in a secure way
//? https://pub.dev/packages/flutter_secure_storage
//* The cookie is important to be stored in a secure way
//* If possible storing the most ammount of user data in a secure way is the best option
//* Recipes can be stored in files, but the user data should be stored in a secure way

// TODO: Add the number of likes property to the recipe class and to the recipe json enconder and decoder
//? The server returns a property per recipe called NumLikes, this property should be added to the recipe class

//* Imports
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

//! This is the local server url
String url = 'https://localhost:44322';

class Login {
  String email;
  String username;
  String password;
  String name;
  String? surname;
  //String? phone; //! Not sent

  Login({
    required this.email,
    required this.password,
    this.username = '',
    this.name = '',
    this.surname,
    //this.phone,
  });

  Future<bool> login() async {
    print('Logging in with email: $email and password: $password');

    // Do an API call to the server to login
    var request =
        http.MultipartRequest('POST', Uri.parse('$url/Account/AppLogin'));
    request.fields
        .addAll({'email': email, 'password': password, 'remember me': 'true'});

    //request.headers.addAll(headers); // no headers needed, we only need to get the cookie from the response

    var response = await request.send();
    if (response.statusCode == 200) {
      // if success field is true, save the user data
      var responseBody = await response.stream.bytesToString();

      // Check if it contains the success field and if it has the value true
      if (responseBody.contains('success":true')) {
        print('Login successful');

        // Get the cookie from the response
        var cookie = response.headers['set-cookie'];
        print('Cookie: $cookie');

        // Get the user data from the response
        var username = responseBody.split('username":"')[1].split('"')[0];
        var name = responseBody.split('name":"')[1].split('"')[0];
        var surname = responseBody.split('surname":"')[1].split('"')[0];
        var guid = responseBody.split('id":"')[1].split('"')[0];

        // Save the user data to user.json
        // ignore: use_build_context_synchronously
        User user = User(
          cookie: cookie!,
          guid: guid,
          email: email,
          username: username,
          name: name,
          surname: surname,
        );
        user.save();

        return true;
      } else {
        print('Login failed');
        print('Response: $responseBody');
        return false;
      }
    } else {
      print(" ---> (0002) ${response.reasonPhrase}");
      return false;
    }
  }
}

class Register {
  String email;
  String username;
  String password;
  String confirmPassword;
  String name;
  String? surname;
  //String? phone; //! Not sent

  Register({
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.name,
    this.surname,
    //this.phone,
  });

  Future<bool> register() async {
    if (password != confirmPassword) {
      print('Passwords do not match');
      return false;
    }
    print('Registering with email: $email, username: $username, name: $name');

    // Do an API call to the server to register
    var request =
        http.MultipartRequest('POST', Uri.parse('$url/Account/AppRegister'));
    request.fields.addAll({
      'email': email,
      'username': username,
      'password': password,
      'name': name,
      'surname': surname ?? '',
      //'phone': phone ?? '',
    });

    //request.headers.addAll(headers); // no headers needed, we only need to get the cookie from the response

    var response = await request.send();
    if (response.statusCode == 200) {
      // if success field is true, save the user data
      var responseBody = await response.stream.bytesToString();

      // Check if it contains the success field and if it has the value true
      if (responseBody.contains('success":true')) {
        print('Register successful');

        // Get the cookie from the response
        var cookie = response.headers['set-cookie'];
        print('Cookie: $cookie');

        // Get the user data from the response
        var username = responseBody.split('username":"')[1].split('"')[0];
        var name = responseBody.split('name":"')[1].split('"')[0];
        var surname = responseBody.split('surname":"')[1].split('"')[0];
        var guid = responseBody.split('id":"')[1].split('"')[0];

        // Save the user data to user.json
        // ignore: use_build_context_synchronously
        User user = User(
          cookie: cookie!,
          guid: guid,
          email: email,
          username: username,
          name: name,
          surname: surname,
        );
        user.save();

        return true;
      } else {
        print('Register failed');
        print('Response: $responseBody');
        return false;
      }
    } else {
      print(" ---> (0003) ${response.reasonPhrase}");
      return false;
    }
  }
}

// A Class to save user data
class User {
  String cookie;
  String guid;
  String email;
  String username;
  String name;
  String? surname;
  int type = 3;

  //String? phone; //! Not sent

  User({
    required this.cookie,
    required this.guid,
    required this.email,
    required this.username,
    required this.name,
    this.surname,
    //this.phone,
  }) {
    checkFiles();
  }

  String getFilePath() {
    var file = File('user.json');
    print('File path: ${file.path}');
    return file.path;
  }

  bool isEmpty() {
    // If the user data like cookie and guid are empty, return false
    if (cookie.isEmpty || guid.isEmpty) {
      return true;
    }
    return false;
  }

  factory User.getInstance() {
    var file = File('user.json');
    if (!file.existsSync() || file.lengthSync() == 0) {
      //print('File does not exist or is empty');

      // Returns an empty user signaling that there is no user logged in or saved
      return User(
          cookie: '', guid: '', email: '', username: '', name: '', surname: '');
    }

    // Read the user data from user.json with json format using the fromJson method
    var json = file.readAsStringSync();
    var decodedJson = jsonDecode(json);
    var user = User.fromJson(decodedJson);

    // Returns the information about the user that is saved in the user.json file
    return User(
      cookie: user.cookie,
      guid: user.guid,
      email: user.email,
      username: user.username,
      name: user.name,
      surname: user.surname,
    );
  }

  // Get the user data from a json object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      cookie: json['cookie'],
      guid: json['guid'],
      email: json['email'],
      username: json['username'],
      name: json['name'],
      surname: json['surname'],
    );
  }

  // Convert the user data to a json object
  Map<String, dynamic> toJson() {
    return {
      'cookie': cookie,
      'guid': guid,
      'email': email,
      'username': username,
      'name': name,
      'surname': surname,
    };
  }

  // Validates the cookie by sending a request to the server asking if it is valid, the server returns a response with a success field
  Future<bool> validateCookie() async {
    // Do an API call to the server to validate the cookie, the cookie is set to a header on the request and no body is needed
    var request = http.Request('GET', Uri.parse('$url/Account/AmILoggedIn'));
    request.headers.addAll({'cookie': cookie});

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        //print(" ---> ${await response.stream.bytesToString()}");

        // if success field is true, save the user data
        var responseBody = await response.stream.bytesToString();
        if (responseBody.contains('success":true')) {
          print('Cookie is valid');
          return true;
        } else {
          print('Cookie is invalid');
          print('Response: $responseBody');
          return false;
        }
      } else {
        print(" ---> (0004) ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  factory User.delete() {
    var file = File('user.json');
    file.deleteSync();

    print('Deleted user.json');
    return User(
        cookie: '', guid: '', email: '', username: '', name: '', surname: '');
  }

  void checkFiles() {
    // Check if user.json exists
    var file = File('user.json');
    if (!file.existsSync()) {
      print('File does not exist');
      createFiles();
    } else {
      //print('File exists');
    }
  }

  void createFiles() {
    // Create user.json
    var file = File('user.json');
    file.createSync();

    print('Created user.json, ${file.path}');
  }

  // Save to local storage (user.json)
  void save() {
    // Save the user data to user.json
    var file = File('user.json');
    file.writeAsStringSync(
        '{"cookie": "$cookie","guid": "$guid","email": "$email", "username": "$username", "name": "$name", "surname": "$surname"}');

    print('Saved user data to user.json');
  }
}

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
      isPublic: json['isPublic'],
      author: json['Author'], //! ??
      likes: json['NumLikes'],
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
      'author': author,
      'likes': likes,
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

  void setTitle(String title) {
    this.title = title;
  }

  void setDescription(String description) {
    this.description = description;
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

  void setTime(double time) {
    this.time = time;
  }

  void setServings(double servings) {
    this.servings = servings;
  }

  void setType(int type) {
    this.type = type;
  }

  // void set public
  void setPublic(bool isPublic) {
    this.isPublic = isPublic;
  }

  void saveRecipe() {
    // Save the recipe to the application files
    String name = '$id.json';

    var file = File(name);
    // The encoded image is saved as a string so it's not a problem
    file.writeAsStringSync(jsonEncode(this));

    saveImage();
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

Future<File> loadImage(String id) async {
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

          return file;
        } else {
          print('Failed to get image');
          print('Response: $responseBody');
          return file;
        }
      } else {
        print(" ---> (0008) ${response.reasonPhrase}");
        return file;
      }
    } catch (e) {
      print('Error: $e');
      return file;
    }
  }
  return file;
}

Future<Image> getRecipeImage(String id,
    [Map<String, Image>? imageCache]) async {
  var request =
      http.Request('GET', Uri.parse('$url/Recipes/RecipeImage?id=$id'));
  request.headers.addAll({'Cookie': User.getInstance().cookie});

  // Prevents "null check operator used on a null value" error
  imageCache ??= {};
  if (imageCache.containsKey(id)) {
    return imageCache[id]!;
  }

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      var bytes = await response.stream.toBytes();
      var contentType = response.headers['content-type'];

      if (contentType != null && contentType.startsWith('image/')) {
        // Save the image to the application files
        //! var file = File('images/$id.jpg');
        //! file.writeAsBytesSync(bytes);
        //? Not done here because the function cannot change the state of the widget that calls it
        //?imageCache[id] = Image.memory(bytes);

        return Image.memory(bytes);
      } else {
        print('Failed to get image: Invalid content type');
        return Image.asset('assets/images/placeholder.png');
      }
    } else {
      print(" ---> (0009) ${response.reasonPhrase}");
      return Image.asset('assets/images/placeholder.png');
    }
  } catch (e) {
    print('Error: $e');
    return Image.asset('assets/images/placeholder.png');
  }
}

Future<List<Recipe>> getMyRecipes() async {
  // Get the user's recipes from the server
  var request = http.Request('GET', Uri.parse('$url/Recipes/GetMyRecipes'));
  request.headers.addAll({'cookie': User.getInstance().cookie});

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

            for (var ingredient in recipe['Ingredients']) {
              var ing = Ingredient.fromJson(ingredient);
              ing.save();
            }

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

Future<List<Recipe>> getSearchRecipes(String search, int type) async {
  // Get the user's recipes from the server
  var request = http.Request('GET', Uri.parse('$url/Recipes/Search'));
  request.headers.addAll({'cookie': User.getInstance().cookie});
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
Future<List<Recipe>> getPopularRecipes(int totalPages, [int page = 0]) async {
  // Get the user's recipes from the server
  var request = http.Request('GET', Uri.parse('$url/Recipes/GetPopular'));
  request.headers.addAll({'cookie': User.getInstance().cookie});
  request.bodyFields = {'page': page.toString()};

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

        totalPages = json['totalPages'];

        print(recipeinfos);
        for (var recipe in recipeinfos) {
          try {
            // Creates a temporary recipe object
            Recipe rcp = Recipe.fromJson(recipe);

            //! For now it won't save the ingredients, it will load them every time
            //! Not practical to save the ingredients of recipes from other people
            //for (var ingredient in recipe['Ingredients']) {
            //  var ing = Ingredient.fromJson(ingredient);
            //  ing.save();
            //}

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

class Ingredient {
  String id;
  String name;
  String unit;
  bool isVerified;
  String? tag;

  Ingredient({
    required this.id,
    required this.name,
    required this.unit,
    this.isVerified = false,
    this.tag,
  });

  // TODO: This function does not work
  void save() {
    // Create directory
    var dir = Directory('recipes/ingredients');
    if (!dir.existsSync()) {
      dir.createSync();
    }
    // Save the ingredient to the application files
    String name = 'recipes/ingredients/$id.json';

    var file = File(name);
    file.writeAsStringSync(jsonEncode(toJson()));
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['GUID'],
      name: json['Name'],
      unit: json['Unit'] ?? '',
      isVerified: json['isVerified'] ?? false,
      tag: json['Tag'] ?? '',
    );
  }

  // Convert into json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'isVerified': isVerified,
      'tag': tag,
    };
  }

  void saveWithIng(Ingredient ingredient) {
    // Create directory
    var dir = Directory('recipes/ingredients');
    if (!dir.existsSync()) {
      dir.createSync();
    }
    // Save the ingredient to the application files
    String name = 'recipes/ingredients/${ingredient.id}.json';

    // Update the current instance with the new ingredient
    id = ingredient.id;
    name = ingredient.name;
    unit = ingredient.unit;
    isVerified = ingredient.isVerified;
    tag = ingredient.tag;

    var file = File(name);
    file.writeAsStringSync(jsonEncode(ingredient));
  }
}

class IngBridge {
  String id;
  String ingredient; // Ingredient id
  double amount;
  String? customUnit;

  IngBridge({
    required this.id,
    required this.ingredient,
    required this.amount,
    this.customUnit,
  });

  factory IngBridge.fromJson(Map<String, dynamic> json) {
    return IngBridge(
      id: json['GUID'],
      ingredient: json['IngGUID'],
      amount: (json['Amount'] is int)
          ? (json['Amount'] as int).toDouble()
          : (json['Amount'] ?? 0.0) as double,
      customUnit: json['CustomUnit'],
    );
  }

  // Override equality operator to compare based on the `ingredient` field
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IngBridge && other.ingredient == ingredient;
  }

  @override
  int get hashCode => ingredient.hashCode;
}

// Other functions

Future<Recipe> fetchRecipe(String id) async {
  // Check if there is a file with the recipe id
  var file = File('recipes/$id.json');

  if (!Directory("recipes").existsSync()) {
    Directory("recipes").createSync();
  }

  // Check if the file exists and check if the directory exists
  if (file.existsSync()) {
    // Read the recipe data from the file with json format using the fromJson method

    try {
      var json = file.readAsStringSync();
      var decodedJson = jsonDecode(json);
      var recipe = Recipe.fromJson(decodedJson);

      // Return the recipe
      return recipe;
    } catch (e) {
      print('Error fetching the recipe $id: $e');
      return Recipe.defaultR();
    }
  } else {
    // Fetch the recipe from the server
    var request =
        http.Request('GET', Uri.parse('$url/Recipes/GetRecipe?id=$id'));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        //print(" ---> ${await response.stream.bytesToString()}");

        // if success field is true, save the user data
        var responseBody = await response.stream.bytesToString();
        if (responseBody.contains('"error":""')) {
          print('Got recipe');

          // Parse the JSON response and return the recipe
          var json = jsonDecode(responseBody);
          var recipe = Recipe.fromJson(json);

          // Save the recipe to the application files
          file.writeAsStringSync(jsonEncode(recipe));

          return recipe;
        } else {
          print('Failed to get recipe');
          print('Response: $responseBody');
          return Recipe.defaultR();
        }
      } else {
        // If the status code is anything but 200, return a default recipe
        print(" ---> (0015) ${response.reasonPhrase}");
        return Recipe.defaultR();
      }
    } catch (e) {
      print('Error: $e');
      return Recipe.defaultR();
    }
  }
}

// Fetches the ingredients of a specific recipe
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
    // Fetch the recipe from the server
    ////~TODO: Server is refusing to allow the request, always returning 404 (Not Found)
    var request = http.Request(
        'GET', Uri.parse('$url/Recipes/GetIngredientsByRecipe?Id=$id'));
    request.headers.addAll({'cookie': User.getInstance().cookie});

    print("Cookie: ${User.getInstance().cookie}");

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

// Fetches the ingredients of a specific recipe with the id of the recipe
Future<List<Ingredient>> RecipeIngredients(String Id) async {
  // localhost:44322/Recipes/GetIngredientsByRecipe?Id=630fd198-beba-4f57-944d-8eb7907d8f65
  // This one is only online, doesn't check the local files
  var request = http.Request(
      'GET', Uri.parse('$url/Recipes/GetIngredientsByRecipe?Id=$Id'));
  request.headers.addAll({'cookie': User.getInstance().cookie});

  try {
    // TODO: Doesn't return values
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
          return [Ingredient(id: Id, name: 'Ingredient Fail 4', unit: 'Unit')];
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
        return [Ingredient(id: Id, name: 'Ingredient Fail 1', unit: 'Unit')];
      }
    } else {
      // If the status code is anything but 200, return a default recipe
      print(" ---> (0018) ${response.reasonPhrase}");
      return [Ingredient(id: Id, name: 'Ingredient Fail 2', unit: 'Unit')];
    }
  } catch (e) {
    print('Error: $e');
    return [Ingredient(id: Id, name: 'Ingredient Fail 3', unit: 'Unit')];
  }
}
