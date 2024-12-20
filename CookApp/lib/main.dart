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

  //TODO: Load the recommended recipes
  //? The recommended Recipes are the ones from the getPopularRecipes() Future<List<Recipes>> function

  @override
  void initState() {
    super.initState();

    getPopularRecipes().then((value) {
      setState(() {
        recommended = value;
        rLoaded = true;
      });
    });
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
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              // Early Access Warning
              child: const ListTile(
                title: Text(
                  'ACESSO ANTECIPADO',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  'Esta aplicação contém alguns problemas desconhecidos!',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                leading: Icon(
                  Icons.info_outline,
                  color: Colors.red,
                  size: 25,
                ),
                trailing: Icon(
                  Icons.info_outline,
                  color: Colors.red,
                  size: 25,
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
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 1,
                    child: const Divider(
                      color: Colors.black45,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            rLoaded = false;
                          });
                          getPopularRecipes().then((value) {
                            setState(() {
                              recommended = value;
                              rLoaded = true;
                            });
                          });
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                    ),
                  ),
                ],
              )),

          recommended.isEmpty
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
                        const Text(
                          'Este processo tem problemas de execução',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(recommended[index].title),
                      subtitle: Text(recommended[index].description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetail(
                              recipe: recommended[index],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
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
              builder: (context) => const NewRecipeForm(),
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
