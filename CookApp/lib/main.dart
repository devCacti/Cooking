//? Imports
//import 'package:cookapp/Classes/server_info.dart';
import 'package:cookapp/Pages/Elements/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'Functions/server_requests.dart';
import 'Classes/recipes.dart';
import 'Pages/Recipe Pages/recipe_detail.dart';
import 'Classes/user.dart';
import 'Settings/settings.dart';
//import 'Pages/new_recipe.dart';

//? Unused Imports
////import '../../Pages/Shopping%20Lists/shopping_lists.dart';
////import 'Pages/user_settings.dart';
////import 'Pages/new_recipe.dart';
////import 'Pages/list_recipes.dart';
////import 'Pages/list_favourites.dart';

void main() async {
  Settings settings = Settings.defaultS();
  bool darkMode = await settings.getDarkMode() ?? true;
  themeNotifier.value = darkMode ? ThemeMode.dark : ThemeMode.light;

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(darkMode: darkMode));
}

class MyApp extends StatelessWidget {
  final bool darkMode;
  const MyApp({super.key, required this.darkMode});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Cooking',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          //debugShowCheckedModeBanner: false,
          home: const MyHomePage(
            title: 'Cooking',
          ),
        );
      },
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
  Map<String, Image> imageCache = {};

  Future<void> getRecipeimage(String id) async {
    getRecipeImage(id, imageCache).then((value) {
      setState(() {
        imageCache[id] = value;
      });
    });
  }

  Future<void> fullRefreshRecipes() async {
    setState(() {
      rLoaded = false;
    });
    await getPopularRecipes().then((value) {
      setState(() {
        for (Recipe recipe in value) {
          getRecipeimage(recipe.id);
        }
        recommended = value;
        rLoaded = true;
      });
    });
  }

  @override
  void initState() {
    User user = User.defaultU();
    user.getInstance().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();

    // Refresh the recipes
    fullRefreshRecipes();
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
                color: const Color.fromARGB(19, 115, 115, 115),
              ),
              // Early Access Warning
              child: const ListTile(
                title: Text(
                  'ACESSO ANTECIPADO',
                  style: TextStyle(fontSize: 20),
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
                      onPressed: rLoaded ? () => fullRefreshRecipes() : null,
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
              : ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height / 2.5),
                  child: CarouselView.weighted(
                    controller: CarouselController(),
                    itemSnapping: true,
                    flexWeights: const <int>[1, 9, 1],
                    onTap: (index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetail(
                            recipe: recommended[index],
                            image: imageCache[recommended[index].id],
                          ),
                        ),
                      );
                    },
                    children: recommended.map((recipe) {
                      return Stack(
                        children: [
                          ClipRect(
                            child: Center(
                              child: Image(
                                width: double.infinity,
                                height: double.infinity,
                                image: imageCache[recipe.id]?.image ??
                                    const AssetImage(
                                      'assets/images/LittleMan.png',
                                    ),
                                fit: BoxFit.cover,
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

          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: bottomAppBar(context),
      floatingActionButton: actionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
