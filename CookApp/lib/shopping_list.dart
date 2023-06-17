import 'package:flutter/material.dart';
import 'lista_compra.dart';

class ShoppingListForm extends StatefulWidget {
  const ShoppingListForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ShoppingListFormState createState() => _ShoppingListFormState();
}

class _ShoppingListFormState extends State<ShoppingListForm> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<LstItem> _items = [];
  List<bool> bools = [];
  int id = 1;

  GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  GlobalKey<_ShoppingListFormState> shoppingListFormKey = GlobalKey<_ShoppingListFormState>();

  //?Novo item
  TextEditingController itemN = TextEditingController();
  TextEditingController itemD = TextEditingController();
  String? nItem;
  String? dItem;

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
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  void initializeData() async {
    id = await getNextID();
  }

  void triggerRefresh() {
    refreshIndicatorKey.currentState?.show();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleAnimation() {
    if (_controller.isCompleted || _controller.velocity > 0) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
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
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: () async {
            //* Meter itens com done = true no fim da lista

            loadItems().then((items) {
              setState(() {
                _items = items.toList();
                bools = List<bool>.filled(_items.length, false);
              });
            });

            for (int i = 0; i < _items.length; i++) {
              if (_items[i].done == true) {
                final item = _items.removeAt(i);
                _items.add(item);
                bools.removeAt(i);
                bools.add(true);
              }
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 25),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: itemN,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Artigo',
                        hintText: 'Texto',
                        border: UnderlineInputBorder(),
                      ),
                      onChanged: (value) {
                        nItem = value;
                        toggleAnimation();
                      },
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: itemD,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: 'Descrição (Opcional)',
                        hintText: 'Texto',
                        border: UnderlineInputBorder(),
                      ),
                      onChanged: (value) {
                        dItem = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 25),
                  IconButton(
                    onPressed: () {
                      initializeData();
                      if (nItem != null && nItem != "") {
                        final novoItem = LstItem(
                          id: id,
                          nome: nItem!,
                          descricao: dItem != '' ? dItem : '',
                          done: false,
                        );
                        _items.insert(0, novoItem);
                        update_all_items(_items);
                      }
                      refreshIndicatorKey.currentState?.show();
                      itemN.text = '';
                      itemD.text = '';
                      nItem = '';
                      dItem = '';
                    },
                    icon: const Icon(
                      Icons.add,
                    ),
                    tooltip: 'Novo artigo',
                    iconSize: 50,
                  ),
                  const SizedBox(width: 25),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: MediaQuery.of(context).size.height - 185,
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: bools[index] == true ? Colors.grey[100] : Colors.grey[300],
                          ),
                          child: ListTile(
                            leading: Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                splashRadius: 25,
                                value: _items[index].done ?? false,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      _items[index] = LstItem(
                                        id: _items[index].id,
                                        nome: _items[index].nome,
                                        descricao: _items[index].descricao,
                                        done: value,
                                      );

                                      //?Mudar a posição do item na lista
                                      if (_items[index].done == true) {
                                        final LstItem l = _items[index];
                                        _items.removeAt(index);
                                        _items.insert(_items.length, l);
                                      } else {
                                        final LstItem l = _items[index];
                                        _items.removeAt(index);
                                        _items.insert(0, l);
                                      }
                                      //*Guardar informação na base de dados
                                      update_all_items(_items);
                                    },
                                  );
                                },
                              ),
                            ),
                            title: AnimatedDefaultTextStyle(
                              style: TextStyle(
                                fontSize: 24,
                                color: _items[index].done == true ? Colors.grey : Colors.black,
                              ),
                              duration: const Duration(seconds: 1),
                              child: Text(
                                _items[index].nome,
                              ),
                            ),
                            //?Aplicar animação ao bloco do id que foi alterado
                            subtitle: _items[index].descricao != '' && _items[index].descricao != null
                                ? AnimatedDefaultTextStyle(
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _items[index].done == true ? Colors.grey : Colors.black,
                                    ),
                                    duration: const Duration(seconds: 1),
                                    child: Text(
                                      _items[index].descricao!,
                                    ),
                                  )
                                : null,
                            trailing: GestureDetector(
                              onTap: () {
                                deleteItemById(_items[index].id);
                                triggerRefresh();
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(seconds: 1),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  Icons.delete_outline,
                                  size: 48.0,
                                  key: ValueKey<bool>(!bools[index]),
                                  color: bools[index] ? Colors.red[100] : Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
