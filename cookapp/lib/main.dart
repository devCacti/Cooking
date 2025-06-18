//? Imports
//import 'package:cookapp/Classes/server_info.dart';
import 'package:cookapp/Classes/app_state.dart';
import 'package:cookapp/Classes/snackbars.dart';
import 'package:cookapp/Pages/Elements/app_title.dart';
import 'package:cookapp/Pages/Elements/bottom_app_bar.dart';
import 'package:cookapp/Pages/Elements/early_access.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Functions/server_requests.dart';
import 'Classes/recipes.dart';
import 'Pages/Recipe Pages/recipe_detail.dart';
import 'Settings/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'Pages/new_recipe.dart';

//? Unused Imports
////import '../../Pages/Shopping%20Lists/shopping_lists.dart';
////import 'Pages/user_settings.dart';
////import 'Pages/new_recipe.dart';
////import 'Pages/list_recipes.dart';
////import 'Pages/list_favourites.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, themeMode, __) {
            return MaterialApp(
              locale: appState.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeMode,
              home: MyHomePage(
                title: 'Cooking',
              ),
            );
          },
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
  //? Multiple language support

  //User user = User.defaultU();
  List<Recipe> recommended = [];
  bool rLoaded = false;
  Map<String, Image> imageCache = {};

  Future<void> getRecipeimage(String id) async {
    getRecipeImage(id, context, imageCache).then((value) {
      setState(() {
        imageCache[id] = value ?? Image.asset('assets/images/LittleMan.png');
      });
    });
  }

  Future<void> fullRefreshRecipes() async {
    setState(() {
      rLoaded = false;
    });
    await getPopularRecipes(context).then((value) {
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
    super.initState();

    var appState = context.read<AppState>();
    try {
      appState.getLocale(context); // Load the locale from settings
    } catch (e) {
      showSnackbar(
        context,
        "Exception with locale on main activity: $e",
        type: SnackBarType.error,
        isBold: true,
      );
    }
    Settings.getDarkMode(context).then((value) {
      setState(() {
        themeNotifier.value = (value ? ThemeMode.dark : ThemeMode.light); // Set the theme mode based on the settings
      });
    });
    appState.getUseSecureStorage(context);
    appState.getUser(context);

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
    //final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          //*Early Access
          earlyAccess(context),
          appTitle,

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
                                ? const Text('Não existem receitas recomendadas')
                                : const Text('Aqui estão as receitas recomendadas')
                            : const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                )
              : ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height / 2.5),
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
      bottomNavigationBar: bottomAppBar(context, PageType.home),
      floatingActionButton: actionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
