import '../../Classes/lista_compra.dart';
import 'package:flutter/material.dart';

class ViewList extends StatefulWidget {
  final ListClass list;

  const ViewList({super.key, required this.list});

  @override
  // ignore: library_private_types_in_public_api
  _ViewListState createState() => _ViewListState();
}

class _ViewListState extends State<ViewList> {
  TextEditingController nomeController = TextEditingController(text: '');
  TextEditingController quantidadeController = TextEditingController(text: '');
  TextEditingController precoController = TextEditingController(text: '');

  double get totalValor {
    double total = 0;
    for (var item in widget.list.items!) {
      total += item.preco * item.quantidade;
    }
    return total;
  }

  double get totalQuantidade {
    double total = 0;
    for (var item in widget.list.items!) {
      total += item.quantidade;
    }
    return total;
  }

  //Init State to load everything
  @override
  void initState() {
    super.initState();
  }

  bool get allItemsChecked {
    for (var item in widget.list.items!) {
      if (!item.checked) {
        return false;
      }
    }
    return widget.list.items!.isNotEmpty;
  }

  set allItemsChecked(bool value) {
    for (var item in widget.list.items!) {
      item.checked = value;
    }
  }

  //? Add Item Dialog
  Future<void> _addItemDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  hintText: 'Item',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: quantidadeController,
                      decoration: const InputDecoration(
                        hintText: 'Quantidade',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: precoController,
                      decoration: const InputDecoration(
                        hintText: 'Preço',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                nomeController.clear();
                quantidadeController.clear();
                precoController.clear();

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                if (nomeController.text != '' &&
                    nomeController.text.isNotEmpty) {
                  if (quantidadeController.text.isNotEmpty) {
                    //replace , with . if it exists
                    quantidadeController.text =
                        quantidadeController.text.replaceAll(',', '.');
                  }
                  widget.list.addItem(
                    ListItem(
                      nome: nomeController.text,
                      quantidade: quantidadeController.text == '' ||
                              quantidadeController.text == '1'
                          ? 1
                          : double.parse(quantidadeController.text),
                      preco: precoController.text == ''
                          ? 0
                          : double.parse(
                              precoController.text,
                            ),
                    ),
                  );
                }
                updateListById(widget.list);
                nomeController.clear();
                quantidadeController.clear();
                precoController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //? Reorder Items based on checked status
  void reorderItems() {
    widget.list.items!.sort((a, b) {
      if (a.checked && !b.checked) return 1; // Checked goes to bottom
      if (!a.checked && b.checked) return -1; // Unchecked goes to top
      return 0; // Otherwise, maintain order
    });
  }

  // ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text(
              widget.list.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            widget.list.descricao == null
                ? const SizedBox()
                : Column(
                    children: [
                      Text(
                        widget.list.descricao!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
            Text(
              widget.list.data == null ? 'Sem Data' : widget.list.data!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            //? Divider
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.black38,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Checkbox(
                tristate: true,
                value: allItemsChecked
                    ? true
                    : widget.list.items!.any((item) => item.checked)
                        ? null
                        : false,
                onChanged: (value) {
                  setState(() {
                    if (value == null) {
                      // Handle the indeterminate state if needed, for example, by checking all items
                      allItemsChecked = true;
                      for (var item in widget.list.items!) {
                        item.checked = true;
                      }
                    }

                    if (allItemsChecked) {
                      allItemsChecked = false;
                      for (var item in widget.list.items!) {
                        item.checked = false;
                      }
                    } else if (value!) {
                      allItemsChecked = true;
                      for (var item in widget.list.items!) {
                        item.checked = true;
                      }
                    } else {
                      for (var item in widget.list.items!) {
                        item.checked = true;
                      }
                    }
                    updateListById(widget.list);
                  });
                },
              ),
              title:
                  // Item Name
                  SizedBox(
                child: Text(
                  "Item",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width / 5,
                child: Icon(
                  Icons.add_shopping_cart_rounded,
                  size: 30,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 5),
            //? Divider
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.black12,
            ),
            const SizedBox(height: 5),

            //Builder
            widget.list.items!.isEmpty
                //? If there are no items
                ? const Center(
                    child: Text(
                      'Esta lista não tem itens',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  )
                //? If there are items
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: widget.list.items![index].checked
                            ? 0.5
                            : 1.0, // Fade effect for checked items
                        child: Column(
                          children: [
                            Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 5,
                              child: ListTile(
                                leading: Checkbox(
                                  value: widget.list.items![index].checked,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.list.items![index].checked =
                                          value!;
                                      updateListById(
                                          widget.list); // Your update logic
                                      reorderItems(); // Reorder the list
                                    });
                                  },
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        widget.list.items![index].nome,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: SizedBox(
                                  width: MediaQuery.of(context).size.width / 5,
                                  child: Text(
                                    widget.list.items![index].quantidade
                                        .toStringAsFixed(widget.list
                                                    .items![index].quantidade
                                                    .truncateToDouble() ==
                                                widget.list.items![index]
                                                    .quantidade
                                            ? 0
                                            : widget
                                                .list.items![index].quantidade
                                                .toString()
                                                .split('.')
                                                .last
                                                .length)
                                        .replaceAll('.', ','),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                    itemCount: widget.list.items!.length,
                    shrinkWrap: true,
                    // Don't allow for scrolling
                    physics: const NeverScrollableScrollPhysics(),
                  ),
            //? Divider
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.black12,
            ),

            const SizedBox(height: 10),
            ListTile(
              leading: Checkbox(
                tristate: true,
                value: allItemsChecked
                    ? true
                    : widget.list.items!.any((item) => item.checked)
                        ? null
                        : false,
                onChanged: (value) {
                  setState(() {
                    if (value == null) {
                      // Handle the indeterminate state if needed, for example, by checking all items
                      allItemsChecked = true;
                      for (var item in widget.list.items!) {
                        item.checked = true;
                      }
                    }

                    if (allItemsChecked) {
                      allItemsChecked = false;
                      for (var item in widget.list.items!) {
                        item.checked = false;
                      }
                    } else if (value!) {
                      allItemsChecked = true;
                      for (var item in widget.list.items!) {
                        item.checked = true;
                      }
                    } else {
                      for (var item in widget.list.items!) {
                        item.checked = true;
                      }
                    }
                    updateListById(widget.list);
                  });
                },
              ),
              title: SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: const Text(
                  'Total',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              trailing: SizedBox(
                width: MediaQuery.of(context).size.width / 5,
                child: Text(
                  totalQuantidade
                      .toStringAsFixed(totalQuantidade.truncateToDouble() ==
                              totalQuantidade
                          ? 0
                          : totalQuantidade.toString().split('.').last.length)
                      .replaceAll('.', ','),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ////SizedBox(
              ////  width: MediaQuery.of(context).size.width / 4,
              ////  child: Text(
              ////    '${totalValor.toStringAsFixed(totalValor.truncateToDouble() == totalValor ? 0 : totalValor.toString().split('.').last.length).replaceAll('.', ',')}€',
              ////    textAlign: TextAlign.center,
              ////    style: const TextStyle(
              ////      fontSize: 20,
              ////      fontWeight: FontWeight.bold,
              ////    ),
              ////  ),
              ////),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          _addItemDialog().then((value) {
            setState(() {});
          });
        },
        child: const Icon(
          Icons.add_rounded,
          size: 45,
        ),
      ),
    );
  }
}
