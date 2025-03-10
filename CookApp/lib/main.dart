//? Imports
//import 'package:cooking_app/Classes/server_info.dart';
import 'package:cooking_app/Pages/Elements/bottom_app_bar.dart';
import 'package:flutter/material.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      //debugShowCheckedModeBanner: false,
      home: const MyHomePage(
        title: 'Cooking',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //User user = User.defaultU();
  List<Recipe> recommended = [];
  bool rLoaded = false;
  int rIndex = 0;
  int rMax = 0;
  Map<String, Image> imageCache = {};

  //* Load the recommended recipes (TODO Done ✅)
  //? The recommended Recipes are the ones from the getPopularRecipes(rMax,) Future<List<Recipes>> function

  @override
  void initState() {
    User user = User.defaultU();
    user.getInstance().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();

    // Gets the Popular Recipes from the server (Not the recommended ones)
    getPopularRecipes(rIndex).then((value) {
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

    // // Get the user instance
    // user.getInstance().then((value) {
    //   setState(() {
    //     user = value;
    //   });
    // });
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
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 30, right: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey[200],
              ),
              // Early Access Warning
              child: const ListTile(
                title: Text(
                  'ACESSO ANTECIPADO',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  'Pode perder tudo o que tiver durante esta fase!',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                leading: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 30,
                ),
                trailing: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fastfood_rounded,
                  size: 40,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Cooking',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.local_dining_sharp,
                  size: 40,
                ),
              ],
            ),
          ),
          const Divider(
            indent: 50,
            endIndent: 50,
            color: Colors.black,
          ),

          //* Recommended Recipes
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 32, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const Text(
                    'Tendências',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: 1,
                  child: const Divider(
                    color: Colors.black45,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          rLoaded = false;
                        });
                        getPopularRecipes(0).then((value) {
                          setState(() {
                            rIndex = 0;
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
          recommended.isEmpty //? If there are no recipes, show a message
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        rLoaded
                            ? recommended.isEmpty
                                ? const Text(
                                    'Não existem receitas recomendadas')
                                : const Text(
                                    'Aqui estão as receitas recomendadas')
                            : const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32, right: 32),
                    child: ListView.builder(
                      itemCount: recommended.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 2, bottom: 10, left: 10, right: 10),
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(16),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              leading: FutureBuilder<Image>(
                                future: getRecipeImage(
                                    recommended[index].id, imageCache),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    imageCache[recommended[index].id] =
                                        snapshot.data!;
                                    if (snapshot.hasError) {
                                      return const Icon(Icons.error);
                                    }
                                    if (snapshot.data?.image ==
                                        const AssetImage(
                                            'assets/images/placeholder.png')) {
                                      return const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Icon(
                                          Icons.image_not_supported_rounded,
                                          size: 50,
                                          color: Colors.black38,
                                        ),
                                      );
                                    } else {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: snapshot.data!,
                                      );
                                    }
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                              title: Text(recommended[index].title),
                              subtitle: Text(recommended[index].description),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetail(
                                      recipe: recommended[index],
                                      image: imageCache[recommended[index].id]!,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
          rMax == 0 //? If there are no pages, show a loading indicator
              ? const Column(
                  children: [
                    Icon(Icons.sync_problem_rounded, size: 50),
                    SizedBox(height: 10),
                  ],
                )
              : Column(
                  children: [
                    const Text("Página", style: TextStyle(fontSize: 18)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_left_rounded),
                          iconSize: 30,
                          onPressed: () {
                            if (rIndex > 0) {
                              int index = rIndex - 1;
                              getPopularRecipes(index).then((value) {
                                setState(() {
                                  recommended = value;
                                  rLoaded = true;
                                  rIndex = index;
                                });
                              });
                            }
                          },
                        ),
                        Text(
                          '${rIndex + 1} / $rMax',
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.keyboard_arrow_right_rounded),
                          iconSize: 30,
                          onPressed: () {
                            if (rIndex < rMax - 1) {
                              int index = rIndex + 1;
                              getPopularRecipes(index).then((value) {
                                setState(() {
                                  recommended = value;
                                  rLoaded = true;
                                  rIndex = index;
                                });
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: bottomAppBar(context),
      floatingActionButton: actionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
