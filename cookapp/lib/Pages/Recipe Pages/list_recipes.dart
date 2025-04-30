import 'package:flutter/material.dart';
import 'package:cookapp/Functions/server_requests.dart';
import 'package:cookapp/Pages/Recipe%20Pages/recipe_detail.dart';
import 'package:cookapp/Classes/recipes.dart';
import 'package:cookapp/Pages/Recipe Pages/edit_recipe_page.dart';
//? List of recipes page
//* Only shows the recipes that are created by the user

class ListRecipesForm extends StatefulWidget {
  const ListRecipesForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListRecipesFormState createState() => _ListRecipesFormState();
}

class _ListRecipesFormState extends State<ListRecipesForm> {
  List<Recipe> _recipes = [];
  String categoria = 'Geral';
  bool rLoaded = false;
  Map<String, Image> imageCache = {};

  @override
  void initState() {
    super.initState();
    ////loadRecipes().then((recipes) {
    ////  setState(() {
    ////    _recipes = recipes;
    ////  });
    ////});

    // Gets a list of the user's recipes
    // (2025-02-12) - This function returns all of the user's recipes
    Future<void> getRecipeimage(String id) async {
      getRecipeImage(id, imageCache).then((value) {
        setState(() {
          imageCache[id] = value ?? Image.asset('assets/images/LittleMan.png');
        });
      });
    }

    setState(() {
      rLoaded = false;
    });
    getMyRecipes().then((returnedValue) {
      setState(() {
        _recipes = returnedValue;
        rLoaded = true;
        for (Recipe recipe in returnedValue) {
          getRecipeimage(recipe.id);
        }
      });
    });
  }

  GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Future decisionDialog(
    BuildContext context,
    String id,
    int index,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar ou Eliminar'),
          content: const Text('Deseja editar esta receita ou eliminá-la permanentemente?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditForm(
                      toEditR: _recipes[index],
                    ),
                  ),
                ).then((_) {
                  refreshIndicatorKey.currentState?.show();
                });
              },
              child: const Text('Editar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showConfirmationDialog(context, id);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> showConfirmationDialog(BuildContext context, String id) async {
    bool confirm = false;
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Eliminar?',
          ),
          content: const Text(
            'Esta ação é irrevertível!',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Deletes the recipe from the database
                RecipeC instance = RecipeC.defaultR();
                confirm = true;
                instance.delete(id).then((_) {
                  getMyRecipes().then((recipes) {
                    setState(() {
                      _recipes = recipes;
                    });
                  });
                });
                Navigator.pop(context);
              },
              child: const Text('Sim'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
    return confirm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButton<String>(
              value: categoria,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                // themeNotifier.value == ThemeMode.dark
                //? Colors.white
                //: Colors.black,
              ),
              items: <String>[
                'Geral',
                'Bolos',
                'Tartes',
                'Sobremesas',
                'Pratos',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? novaCategoria) {
                setState(() {
                  categoria = novaCategoria!;
                });
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //! CASO ESTEJA ALGO A CORRER MAL PODEM SER ESTES ELEMENTOS O PROBLEMA!
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: MediaQuery.of(context).size.height,
                  child: RefreshIndicator(
                    key: refreshIndicatorKey,
                    onRefresh: () async {
                      getMyRecipes().then((recipes) {
                        setState(() {
                          _recipes = recipes;
                        });
                      });
                    },
                    child: _recipes.isEmpty == true
                        ? const Text('Nenhuma receita encontrada...')
                        : ListView.builder(
                            itemCount: _recipes.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (_recipes[index].getType() != categoria && categoria != 'Geral') {
                                return Container();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 12,
                                  top: 4,
                                  bottom: 4,
                                ),
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(16),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RecipeDetail(
                                            recipe: _recipes[index],
                                            image: imageCache[_recipes[index].id],
                                          ),
                                        ),
                                      );
                                    },
                                    onLongPress: () {
                                      decisionDialog(
                                        context,
                                        _recipes[index].id,
                                        index,
                                      );
                                    },
                                    title: Text(
                                      _recipes[index].title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    subtitle: Text(
                                      _recipes[index].description,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    leading: imageCache[_recipes[index].id] != null
                                        ? SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: ClipRRect(
                                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                child: Image(
                                                  image: imageCache[_recipes[index].id]!.image,
                                                  fit: BoxFit.cover,
                                                )),
                                          )
                                        : const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                            size: 50,
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
