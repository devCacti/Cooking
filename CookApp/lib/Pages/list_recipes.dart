import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Classes/receita.dart';
import 'edit_recipe_page.dart';
import 'details_recipes_page.dart';

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
    loadRecipes().then((recipes) {
      setState(() {
        _recipes = recipes;
      });
    });
  }

  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future decisionDialog(
    BuildContext context,
    int id,
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

  Future<bool> showConfirmationDialog(BuildContext context, int id) async {
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
                deleteRecipeById(id).then((_) {
                  loadRecipes().then((recipes) {
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
                      loadRecipes().then((recipes) {
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
                              if (_recipes[index].categoria != categoria &&
                                  categoria != 'Geral') {
                                return Container();
                              }
                              return Padding(
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black12,
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsForm(
                                            detailRecipe: _recipes[index],
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
                                      _recipes[index].nome,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    subtitle: Text(
                                      _recipes[index].descricao,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    leading: _recipes[index].foto != null
                                        ? SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4)),
                                              child: Image.file(
                                                File(_recipes[index].foto!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                          ),
                                    trailing: _recipes[index].favorita
                                        ? const Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 30,
                                          )
                                        : null,
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
