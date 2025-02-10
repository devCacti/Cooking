import 'package:flutter/material.dart';
import '../../Pages/Shopping%20Lists/shopping_lists.dart';
import 'Functions/data_structures.dart';
import 'Pages/Recipe Pages/recipe_detail.dart';
import 'Pages/user_settings.dart';
import 'Pages/new_recipe.dart';
import 'Pages/list_recipes.dart';
import 'Pages/list_favoritas.dart';

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
      debugShowCheckedModeBanner: false,
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
  List<Recipe> recommended = [];
  bool rLoaded = false;
  int rIndex = 0;
  int rMax = 0;
  Map<String, Image> imageCache = {};

  //TODO: Load the recommended recipes
  //? The recommended Recipes are the ones from the getPopularRecipes(rMax,) Future<List<Recipes>> function

  @override
  void initState() {
    super.initState();

    getPopularRecipes(rIndex).then((value) {
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
            padding: const EdgeInsets.only(left: 16, right: 16),
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
                      fontSize: 24,
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
                    padding: const EdgeInsets.only(left: 42.0, right: 42.0),
                    child: ListView.builder(
                      itemCount: recommended.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(10),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
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
                                    return SizedBox(
                                      height: double.infinity,
                                      child: snapshot.data,
                                    );
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //Shopping List Button
            IconButton(
              icon: const Icon(Icons.list),
              tooltip: 'Lista de Compras',
              iconSize: 35,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShoppingLists(),
                  ),
                );
              },
            ),
            //Recipes       Button
            IconButton(
              icon: const Icon(Icons.book_outlined),
              tooltip: 'Receitas',
              iconSize: 35,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListRecipesForm(),
                  ),
                );
              },
            ),
            //Favourites    Button
            IconButton(
              icon: const Icon(Icons.favorite_outline),
              tooltip: 'Favoritas',
              iconSize: 35,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListFavoutiresForm(),
                  ),
                );
              },
            ),
            //Profile       Button
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              tooltip: 'Perfil',
              iconSize: 35,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserSettings(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewRecipeForm(context: context),
            ),
          );
        },
        tooltip: 'Nova Receita',
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
