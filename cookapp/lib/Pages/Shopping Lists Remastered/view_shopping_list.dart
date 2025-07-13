import 'package:cookapp/Classes/Shopping/list_item.dart';
import 'package:cookapp/Classes/Shopping/shopping_list.dart';
import 'package:flutter/material.dart';

class ViewList extends StatefulWidget {
  final ShoppingList list;

  const ViewList({super.key, required this.list});

  @override
  // ignore: library_private_types_in_public_api
  _ViewListState createState() => _ViewListState();
}

class _ViewListState extends State<ViewList> {
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController quantityController = TextEditingController(text: '');

  ShoppingList get list => widget.list;

  double get totalQuantidade {
    double total = 0;
    for (var item in list.ListItems) {
      total += item.Quantity ?? 1;
    }
    return total;
  }

  //Init State to load everything
  @override
  void initState() {
    super.initState();
  }

  bool get allItemsChecked {
    for (var item in list.ListItems) {
      if (!item.Checked!) {
        return false;
      }
    }
    return list.ListItems.isNotEmpty;
  }

  set allItemsChecked(bool value) {
    for (var item in list.ListItems) {
      item.Checked = value;
    }
  }

  //? Add Item Dialog
  Future<void> _addItemDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Adicionar Item',
            textAlign: TextAlign.center,
          ),
          content: Wrap(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Nome do Item',
                  // All around border
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                ),
              ),
              const SizedBox(height: 55),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  hintText: 'Quantidade',
                  // All around border
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    nameController.clear();
                    quantityController.clear();

                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Adicionar'),
                  onPressed: () {
                    try {
                      if (nameController.text != '' && nameController.text.isNotEmpty) {
                        if (quantityController.text.isNotEmpty) {
                          //replace , with . if it exists
                          quantityController.text = quantityController.text.replaceAll(',', '.');
                        }
                        widget.list.addItem(
                          ListItem(
                            Name: nameController.text,
                            Quantity: double.tryParse(quantityController.text) ?? 1,
                            Checked: false,
                          ),
                        );
                      }
                    } catch (e) {
                      // Handle the error
                      // Show a snackbar or toast
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                          behavior: SnackBarBehavior.floating,
                          showCloseIcon: true,
                          content: Text(
                            'Erro ao adicionar o item',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }
                    ShoppingList.updateList(list.Id, list);
                    // Clear the text fields
                    nameController.clear();
                    quantityController.clear();
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //? Reorder Items based on checked status
  void reorderItems() {
    list.ListItems.sort((a, b) {
      if (a.Checked ?? false) return 1; // Checked goes to bottom
      if (!(a.Checked ?? false) && (b.Checked ?? false)) return -1; // Unchecked goes to top
      return 0; // Otherwise, maintain order
    });
  }

  // ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 5,
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text('Lista de Compras'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text(
              list.Name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            list.Description == null
                ? const SizedBox()
                : Column(
                    children: [
                      Text(
                        list.Description!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
            Text(
              list.CreatedAt == null ? 'Sem Data' : list.CreatedAt!.toString(),
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
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Checkbox(
                  tristate: true,
                  value: allItemsChecked
                      ? true
                      : list.ListItems.any((item) => item.Checked ?? false)
                          ? null
                          : false,
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        // Handle the indeterminate state if needed, for example, by checking all items
                        allItemsChecked = true;
                        for (var item in list.ListItems) {
                          item.Checked = true;
                        }
                      }

                      if (allItemsChecked) {
                        allItemsChecked = false;
                        for (var item in list.ListItems) {
                          item.Checked = false;
                        }
                      } else if (value!) {
                        allItemsChecked = true;
                        for (var item in list.ListItems) {
                          item.Checked = true;
                        }
                      } else {
                        for (var item in list.ListItems) {
                          item.Checked = true;
                        }
                      }
                      ShoppingList.updateList(list.Id, list);
                      reorderItems(); // Reorder the list
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
                  ),
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
            ),
            const SizedBox(height: 5),

            //Builder
            list.ListItems.isEmpty
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
                        opacity: list.ListItems[index].Checked ?? false ? 0.45 : 1.0, // Fade effect for checked items
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 5,
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  onLongPress: () {
                                    //? Delete Item
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Apagar Item',
                                            textAlign: TextAlign.center,
                                          ),
                                          content: const Text(
                                            'Tem certeza que deseja apagar este item?',
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancelar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Apagar'),
                                              onPressed: () {
                                                try {
                                                  list.ListItems.removeAt(index);
                                                  //list.removeItem(list.ListItems[index].id!);
                                                } catch (e) {
                                                  // Handle the error
                                                  // Show a snackbar or toast
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Erro ao apagar o item',
                                                      ),
                                                    ),
                                                  );
                                                }
                                                ShoppingList.updateList(list.Id, list);
                                                reorderItems(); // Reorder the list
                                                Navigator.of(context).pop();
                                                setState(() {});
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  leading: Checkbox(
                                    value: list.ListItems[index].Checked ?? false,
                                    onChanged: (value) {
                                      setState(() {
                                        list.ListItems[index].Checked = value!;
                                        ShoppingList.updateList(list.Id, list);
                                        reorderItems(); // Reorder the list
                                      });
                                    },
                                  ),
                                  title: Text(
                                    list.ListItems[index].Name,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  trailing: SizedBox(
                                    width: MediaQuery.of(context).size.width / 5,
                                    child: Text(
                                      (list.ListItems[index].Quantity ?? 1)
                                          .toStringAsFixed(
                                              (list.ListItems[index].Quantity ?? 1).truncateToDouble() == (list.ListItems[index].Quantity ?? 1)
                                                  ? 0
                                                  : (list.ListItems[index].Quantity ?? 1).toString().split('.').last.length)
                                          .replaceAll('.', ','),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
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
                    itemCount: list.ListItems.length,
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
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Checkbox(
                  tristate: true,
                  value: allItemsChecked
                      ? true
                      : list.ListItems.any((item) => item.Checked ?? false)
                          ? null
                          : false,
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        // Handle the indeterminate state if needed, for example, by checking all items
                        allItemsChecked = true;
                        for (var item in list.ListItems) {
                          item.Checked = true;
                        }
                      }

                      if (allItemsChecked) {
                        allItemsChecked = false;
                        for (var item in list.ListItems) {
                          item.Checked = false;
                        }
                      } else if (value!) {
                        allItemsChecked = true;
                        for (var item in list.ListItems) {
                          item.Checked = true;
                        }
                      } else {
                        for (var item in list.ListItems) {
                          item.Checked = true;
                        }
                      }
                      ShoppingList.updateList(list.Id, list);
                      reorderItems(); // Reorder the list
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
                        .toStringAsFixed(
                            totalQuantidade.truncateToDouble() == totalQuantidade ? 0 : totalQuantidade.toString().split('.').last.length)
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
            ),
            const SizedBox(height: 60),
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
