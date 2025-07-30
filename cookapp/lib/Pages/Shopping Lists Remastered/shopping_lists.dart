import 'package:cookapp/Classes/Shopping/list_store.dart';
import 'package:cookapp/Classes/Shopping/shopping_list.dart';
import 'package:cookapp/Classes/snackbars.dart';
import 'package:cookapp/Functions/time_as_text.dart';
import 'package:cookapp/Pages/Elements/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'create_shopping_list.dart';
import 'view_shopping_list.dart';

class ShoppingLists extends StatefulWidget {
  const ShoppingLists({super.key});

  @override

  // ignore: library_private_types_in_public_api
  _ShoppingListsState createState() => _ShoppingListsState();
}

class _ShoppingListsState extends State<ShoppingLists> {
  List<ShoppingList> shoppingLists = [];
  List<ListStore> stores = [];
  ListStore unCatagorizedStore = ListStore(Name: 'Sem Categoria', isExpanded: false);

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
    await ShoppingList.loadLists().then((value) {
      setState(() {
        shoppingLists = value;
      });
    }).catchError((error) {
      failed();
    });

    await ListStore.load().then((value) {
      setState(() {
        stores = value;
      });
    }).catchError((error) {
      failed();
    });
  }

  failed() {
    showSnackbar(context, 'Ocorreu um erro (ERRO conhecido - Erro 1)', type: SnackBarType.error);
  }

  viewList(ShoppingList list) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewList(
          list: list,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Listas de Compras',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          '${store.Name} (${shoppingLists.where((list) => list.Store?.Name == store.Name).length})',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(store.isExpanded ? Icons.expand_less : Icons.expand_more),
                        onTap: () {
                          setState(() {
                            store.isExpanded = !store.isExpanded;
                          });
                        },
                      ),
                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: store.isExpanded
                            ? Column(
                                children: shoppingLists
                                    .where((list) => list.Store?.Name == store.Name)
                                    .map((list) => ListTile(
                                          leading: Icon(
                                            list.Detailed ? Icons.add_shopping_cart_rounded : Icons.shopping_cart,
                                            color: list.ListColor ?? Colors.grey,
                                            size: 40,
                                          ),
                                          trailing: IconButton(
                                              onPressed: () {
                                                ShoppingList.removeList(list.Id);
                                                setState(() {
                                                  shoppingLists.removeWhere((l) => l.Id == list.Id);
                                                });
                                              },
                                              icon: Icon(Icons.delete)),
                                          title: Text(list.Name),
                                          subtitle: Text('Criada em: ${timeAsText(list.CreatedAt!)}'),
                                          onTap: () => viewList(list),
                                        ))
                                    .toList(),
                              )
                            : SizedBox.shrink(), // Smooth collapse
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Shopping Lists that are not associated with any store
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        '${unCatagorizedStore.Name} (${shoppingLists.where((list) => list.Store == null).length})',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Icon(unCatagorizedStore.isExpanded ? Icons.expand_less : Icons.expand_more),
                      onTap: () {
                        setState(() {
                          unCatagorizedStore.isExpanded = !unCatagorizedStore.isExpanded;
                        });
                      },
                    ),
                    AnimatedSize(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      alignment: Alignment.topCenter,
                      child: unCatagorizedStore.isExpanded
                          ? Column(
                              children: shoppingLists
                                  .where((list) => list.Store == null)
                                  .map((list) => ListTile(
                                        leading: Icon(
                                          list.Detailed ? Icons.add_shopping_cart_rounded : Icons.shopping_cart,
                                          color: list.ListColor ?? Colors.grey,
                                          size: 40,
                                        ),
                                        title: Text(list.Name),
                                        subtitle: Text('Criada em: ${timeAsText(list.CreatedAt!)}'),
                                        onTap: () => viewList(list),
                                      ))
                                  .toList())
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          if (shoppingLists.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'N.º Listas: ${shoppingLists.length}',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          if (shoppingLists.isEmpty)
            const Center(
              child: Text(
                'Nenhuma lista de compras encontrada.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
        ],
      ),
      bottomNavigationBar: bottomAppBar(context, PageType.shoppingList),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Nova Lista',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateList(),
            ),
          ).then((value) => initializeData());
        },
        tooltip: 'Nova Lista',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }
}
