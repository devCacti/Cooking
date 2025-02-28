import 'package:cooking_app/Functions/server_requests.dart';
import 'package:cooking_app/Pages/Recipe%20Pages/recipe_detail.dart';
import 'package:flutter/material.dart';
import '../Classes/recipes.dart';
import 'edit_recipe_page.dart';
//? List of recipes page
//* Only shows the recipes that are created by the user

class ListRecipesForm extends StatefulWidget {
  const ListRecipesForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListRecipesFormState createState() => _ListRecipesFormState();
}

class _ListRecipesFormState extends State<ListRecipesForm> {
  List<Recipe> _recipes = [];
  String categoria = 'Geral';

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
    getMyRecipes().then((returnedValue) {
      setState(() {
        _recipes = returnedValue;
      });
    });
  }

  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
          content: const Text(
              'Deseja editar esta receita ou eliminá-la permanentemente?'),
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
                confirm = true;
                //!deleteRecipeById(id).then((_) {
                //!  loadRecipes().then((recipes) {
                //!    setState(() {
                //!      _recipes = recipes;
                //!    });
                //!  });
                //!});
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
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              dropdownColor: Colors.white,
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
                  height: MediaQuery.of(context).size.height - 90,
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
                              if (_recipes[index].getType() != categoria &&
                                  categoria != 'Geral') {
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
                                  borderRadius: BorderRadius.circular(10),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RecipeDetail(
                                            recipe: _recipes[index],
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
                                    leading: _recipes[index].image != null
                                        ? SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4)),
                                                child: Image(
                                                  image: _recipes[index].image!
                                                      as ImageProvider,
                                                  fit: BoxFit.cover,
                                                )),
                                          )
                                        : const Icon(
                                            Icons.image_not_supported,
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
