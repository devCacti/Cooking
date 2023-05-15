import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/edit_recipe.dart';
import 'receita.dart';
import 'details_recipes.dart';

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
        return Theme(
          data: ThemeData(
            brightness: Brightness.light,
            textTheme: const TextTheme(
              titleMedium: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
          child: CupertinoAlertDialog(
            title: const Text('Editar ou Eliminar'),
            content: const Text(
                'Deseja editar esta receita ou elimina-la permanentemente?'),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  editingDialog(context, _recipes[index], () {
                    refreshIndicatorKey.currentState?.show();
                  });
                },
                child: const Text('Editar'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  showConfirmationDialog(context, id);
                },
                child: const Text('Eliminar'),
              )
            ],
          ),
        );
      },
    );
  }

  Future<bool> showConfirmationDialog(BuildContext context, int id) async {
    bool confirm = false;
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
              brightness: Brightness.dark,
              textTheme: const TextTheme(
                  titleMedium: TextStyle(
                color: Colors.red,
              ))),
          child: CupertinoAlertDialog(
            title: const Text(
              'Eliminar?',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Esta ação é irrevertível!',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
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
                                      showBigDialog(
                                        context,
                                        _recipes[index].foto,
                                        _recipes[index].nome,
                                        _recipes[index].descricao,
                                        _recipes[index].ingredientes,
                                        _recipes[index].ingTipo!,
                                        _recipes[index].ingQuant!,
                                        _recipes[index].procedimento,
                                        _recipes[index].tempo,
                                        _recipes[index].porcoes,
                                        _recipes[index].categoria,
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
