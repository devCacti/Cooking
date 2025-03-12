//? Imports
//import 'package:cookapp/Classes/server_info.dart';
import 'dart:ui';

import 'package:cookapp/Pages/Elements/bottom_app_bar.dart';
import 'package:cookapp/Pages/Elements/early_access.dart';
import 'package:flutter/material.dart';
import 'Classes/server_info.dart';
import 'Functions/server_requests.dart';
import 'Classes/recipes.dart';
import 'Pages/Recipe Pages/recipe_detail.dart';
import 'Classes/user.dart';
//import 'Pages/new_recipe.dart';

//? Unused Imports
////import '../../Pages/Shopping%20Lists/shopping_lists.dart';
////import 'Pages/user_settings.dart';
////import 'Pages/new_recipe.dart';
////import 'Pages/list_recipes.dart';
////import 'Pages/list_favourites.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooking',
      theme: ThemeData(primarySwatch: Colors.green),
      //debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Cooking'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //User user = User.defaultU();
  List<Recipe> recommended = [];
  bool rLoaded = false;
  int rMax = 0;
  Map<String, Image> imageCache = {};
  final CarouselController controller = CarouselController(initialItem: 1);

  //* Load the recommended recipes (TODO Done ✅)
  //? The recommended Recipes are the ones from the getPopularRecipes(rMax,) Future<List<Recipes>> function

  @override
  void initState() {
    User user = User.defaultU();
    user.getInstance("Main").then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();

    // Gets the Popular Recipes from the server (Not the recommended ones)
    getPopularRecipes().then((value) {
      setState(() {
        recommended = value;
        rLoaded = true;
      });
    });

    // Gets the number of pages of the popular recipes
    fetchPopularPages().then((value) {
      setState(() {
        rMax = value;
      });
    });
  }

  @override
  void dispose() {
    imageCache.forEach((key, value) {
      value.image.evict();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          //*Early Access
          version.startsWith('v3') ? const SizedBox() : earlyAccess,
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fastfood_rounded, size: 40),
                SizedBox(width: 20),
                Text(
                  'Cooking',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(width: 20),
                Icon(Icons.local_dining_sharp, size: 40),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const Text(
                    'Tendências',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: 1,
                  child: const Divider(color: Colors.black45),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed:
                          !rLoaded
                              ? null
                              : () {
                                setState(() {
                                  rLoaded = false;
                                });
                                getPopularRecipes(0).then((value) {
                                  setState(() {
                                    recommended = value;
                                    rLoaded = true;
                                  });
                                });
                                fetchPopularPages().then((value) {
                                  setState(() {
                                    rMax = value;
                                  });
                                });
                              },
                      icon: const Icon(Icons.refresh),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //* Recommended Recipes Carousel
          recommended.isEmpty
              ? rLoaded
                  ? const SizedBox()
                  : const CircularProgressIndicator()
              : ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height / 2.5,
                ),
                child: CarouselView.weighted(
                  onTap: (index) {
                    Recipe recipe = recommended[index];
                    print("Recipe: ${recipe.title}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RecipeDetail(
                              recipe: recipe,
                              image: imageCache[recipe.id],
                            ),
                      ),
                    );
                  },
                  padding: EdgeInsets.all(10),
                  itemSnapping: true,
                  controller: controller,
                  elevation: 4,
                  flexWeights: const <int>[1, 10, 1],
                  children:
                      recommended.map((recipe) {
                        if (!imageCache.containsKey(recipe.id)) {
                          getRecipeImage(recipe.id).then((value) {
                            setState(() {
                              imageCache[recipe.id] = value;
                            });
                          });
                        }
                        return Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: ClipRect(
                                  child: Image(
                                    image:
                                        imageCache[recipe.id]?.image ??
                                        const AssetImage(
                                          'Assets/Images/LittleMan.png',
                                        ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      const Color.fromARGB(127, 0, 0, 0),
                                    ],
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    recipe.title,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: Text(
                                    recipe.description,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
        ],
      ),
      bottomNavigationBar: bottomAppBar(context),
      floatingActionButton: actionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
