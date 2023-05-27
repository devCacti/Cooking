import 'package:flutter/material.dart';
import 'lista_compra.dart';

class ShoppingListForm extends StatefulWidget {
  const ShoppingListForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ShoppingListFormState createState() => _ShoppingListFormState();
}

class _ShoppingListFormState extends State<ShoppingListForm> {
  List<LstItem> _items = [];
  List<bool> bools = [];
  int id = 1;

  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  GlobalKey<_ShoppingListFormState> shoppingListFormKey =
      GlobalKey<_ShoppingListFormState>();

  @override
  void initState() {
    super.initState();
    initializeData();
    loadItems().then((items) {
      setState(() {
        _items = items.toList();
        bools = List<bool>.filled(_items.length, false);
      });
    });
  }

  void initializeData() async {
    id = await getNextID();
  }

  void triggerRefresh() {
    refreshIndicatorKey.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Lista de Compras',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            IconButton(
              onPressed: () {
                initializeData();
                final novoItem = LstItem(id: id, nome: 'miau', descricao: 'a');
                saveItem(novoItem);
                initState();
                triggerRefresh();
                shoppingListFormKey.currentState?.triggerRefresh();
              },
              icon: const Icon(
                Icons.add,
              ),
              tooltip: 'Novo artigo',
              iconSize: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: MediaQuery.of(context).size.height - 185,
                  child: RefreshIndicator(
                    key: refreshIndicatorKey,
                    onRefresh: () async {
                      loadItems().then((items) {
                        setState(() {
                          _items = items.toList();
                          bools = List<bool>.filled(_items.length, false);
                        });
                      });
                    },
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black12,
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: bools[index],
                                onChanged: (value) {
                                  setState(() {
                                    bools[index] = value!;
                                  });
                                },
                              ),
                              title: Text(_items[index].nome),
                            ),
                          ),
                        );
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
