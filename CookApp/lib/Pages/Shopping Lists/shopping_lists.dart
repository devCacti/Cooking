import 'package:cooking_app/Classes/lista_compra.dart';
import 'package:cooking_app/Pages/Shopping%20Lists/create_shopping_list.dart';
import 'package:flutter/material.dart';

import 'view_shopping_list.dart';

class ShoppingLists extends StatefulWidget {
  const ShoppingLists({Key? key}) : super(key: key);

  @override

  // ignore: library_private_types_in_public_api
  _ShoppingListsState createState() => _ShoppingListsState();
}

class _ShoppingListsState extends State<ShoppingLists> {
  List<PartialList> lists = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initializeData() async {
    await loadListsSimple().then(((value) {
      setState(() {
        lists = value;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listas de Compras'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: lists.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(50),
                        color: lists[index].color,
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            size: 50,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 5,
                                color: Colors.black45,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(16),
                          child: ListTile(
                            title: Text(lists[index].nome),
                            subtitle: Text(
                              lists[index].data?.toString() ?? 'Erro na Data!',
                              style: TextStyle(
                                color: lists[index].data == null
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            onTap: () async {
                              var listId = lists[index].id;
                              //print("Attempting to load list with id: $listId");
                              await loadListById(listId).then((value) {
                                if (value == null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text(
                                        // When there is an error with the database usually
                                        //* when the id doesn't correspond to any list or the simple list is not empty but the main one is
                                        'Não foi possivel carregar a lista (ERRO conhecido - Erro 1)'),
                                    //dismiss button
                                    action: SnackBarAction(
                                      label: 'OK',
                                      textColor: Colors.red,
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      },
                                    ),
                                  ));
                                  return;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewList(list: value),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(50),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete_outlined,
                            size: 50,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Apagar Lista'),
                                  content: const Text(
                                      'Tem a certeza que deseja apagar esta lista?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await deleteListById(lists[index].id)
                                            .then((value) {
                                          initializeData();
                                        });
                                      },
                                      child: const Text('Apagar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Nova Lista',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateList(),
            ),
          );
        },
        tooltip: 'Nova Lista',
        child: const Icon(Icons.add),
      ),
    );
  }
}
