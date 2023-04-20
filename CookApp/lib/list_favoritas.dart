import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'receita.dart';
import 'details_recipes.dart';

class ListFavoutiresForm extends StatefulWidget {
  const ListFavoutiresForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListFavouritesFormState createState() => _ListFavouritesFormState();
}

class _ListFavouritesFormState extends State<ListFavoutiresForm> {
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    loadRecipes().then((recipes) {
      setState(() {
        _recipes = recipes;
      });
    });
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 48, left: 8, right: 8, bottom: 4),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                                color: Colors.pink,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                tooltip: 'Voltar',
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'Aqui aparecem todas as suas receitas favoritas. ;)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              //! CASO ESTEJA ALGO A CORRER MAL PODEM SER ESTES ELEMENTOS O PROBLEMA!
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: MediaQuery.of(context).size.height - 250,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      loadRecipes().then((recipes) {
                        setState(() {
                          _recipes = recipes;
                        });
                      });
                    },
                    child: ListView.builder(
                      itemCount: _recipes.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (!_recipes[index].favorita) {
                          // Return an empty Container if the recipe is not a favorite
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
                                  _recipes[index].procedimento,
                                  _recipes[index].tempo,
                                  _recipes[index].porcoes,
                                  _recipes[index].categoria,
                                );
                              },
                              onLongPress: () {
                                showConfirmationDialog(
                                  context,
                                  _recipes[index].id,
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
                                      width: 55,
                                      height: 50,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                        child: Image.file(
                                          File(_recipes[index].foto!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.warning,
                                      size: 50,
                                    ),
                              trailing: const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 30,
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
