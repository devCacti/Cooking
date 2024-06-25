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
    initializeDate();
  }

  initializeDate() async {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateList(),
                  ),
                ).then((value) => initializeDate());
              },
              icon: const Icon(Icons.add_shopping_cart_rounded,
                  color: Colors.greenAccent),
              iconSize: 75,
              color: Colors.grey,
            ),
            const SizedBox(height: 40),
            lists.isEmpty
                ? const Text(
                    'Não tem listas de compras',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      //phone height - appbar height - icon height - text height - button height
                      height: MediaQuery.of(context).size.height / 1.5,
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification:
                            (OverscrollIndicatorNotification overscroll) {
                          overscroll.disallowIndicator();
                          return true;
                        },
                        child: ListView.builder(
                          itemCount: lists.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                var listId = lists[index].id;
                                print(
                                    "Attempting to load list with id: $listId");
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
                                      builder: (context) =>
                                          ViewList(list: value),
                                    ),
                                  );
                                });
                              },
                              child: Card(
                                elevation: 1.5,
                                child: ListTile(
                                  title: Text(
                                    lists[index].nome,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  leading: lists[index].color == null
                                      ? const Icon(
                                          Icons.dangerous,
                                          color: Colors.grey,
                                          size: 50,
                                        )
                                      : Icon(
                                          lists[index].detalhada! &&
                                                  lists[index].detalhada != null
                                              ? Icons.settings
                                              : Icons.circle,
                                          color: lists[index].color,
                                          size: 50,
                                        ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      lists[index].descricao == null
                                          ? const SizedBox()
                                          : Text(lists[index].descricao!,
                                              style: const TextStyle(
                                                  fontSize: 16)),
                                      lists[index].descricao == null
                                          ? const SizedBox()
                                          : const SizedBox(height: 10),
                                      Text(lists[index].data!),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    iconSize: 35,
                                    icon: const Icon(
                                      Icons.delete_forever_outlined,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      try {
                                        var confirmationResult =
                                            await deleteConfirmationDialog(
                                                context, 'lista de compras');
                                        if (confirmationResult != null &&
                                            confirmationResult) {
                                          await deleteListById(lists[index].id);
                                          setState(() {
                                            lists.removeAt(index);
                                          });
                                        }
                                      } catch (e) {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                              'Não foi possivel apagar a lista (ERRO conhecido - Erro 1)'),
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
                                      }
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
            //?const SizedBox(height: 20),
            //?ElevatedButton(
            //?  onPressed: () => Navigator.push(
            //?    context,
            //?    MaterialPageRoute(
            //?      builder: (context) => const CreateList(),
            //?    ),
            //?  ),
            //?  child: const Text('Criar Lista'),
            //?),
          ],
        ),
      ),
    );
  }
}
