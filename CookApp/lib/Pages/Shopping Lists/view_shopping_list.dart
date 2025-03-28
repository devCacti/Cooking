import '../../Classes/lista_compra.dart';
import 'package:flutter/material.dart';

class ViewList extends StatefulWidget {
  final ListClass list;

  const ViewList({Key? key, required this.list}) : super(key: key);

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

  // ...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        centerTitle: true,
      ),
      body: Center(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Checked
                SizedBox(
                  width: MediaQuery.of(context).size.width / 10,
                  child: Checkbox(
                    tristate: true,
                    value: allItemsChecked
                        ? true
                        : widget.list.items!.any((item) => item.checked)
                            ? null
                            : false,
                    onChanged: (bool? value) {
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
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: const Text(
                    'Item',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 7,
                  child: const Text(
                    'Quant',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: const Text(
                    'Valor',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: GestureDetector(
                              onLongPress: () {
                                deleteConfirmationDialog(context, 'item')
                                    .then((value) {
                                  if (value != null && value) {
                                    setState(() {
                                      widget.list.items!.removeAt(index);
                                      updateListById(widget.list);
                                    });
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //Checked
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                      child: Checkbox(
                                        value:
                                            widget.list.items![index].checked,
                                        onChanged: (value) {
                                          setState(() {
                                            widget.list.items![index].checked =
                                                value!;
                                            updateListById(widget.list);
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: Text(
                                        widget.list.items![index].nome,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 7,
                                      child: Text(
                                        // Avoiding x.0 values instead just x
                                        widget.list.items![index].quantidade
                                            .toStringAsFixed(widget
                                                        .list
                                                        .items![index]
                                                        .quantidade
                                                        .truncateToDouble() ==
                                                    widget.list.items![index]
                                                        .quantidade
                                                ? 0
                                                : widget.list.items![index]
                                                    .quantidade
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
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      child: Text(
                                        '${widget.list.items![index].preco.toStringAsFixed(widget.list.items![index].preco.truncateToDouble() == widget.list.items![index].preco ? 0 : widget.list.items![index].preco.toString().split('.').last.length).replaceAll('.', ',')}€',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                    itemCount: widget.list.items!.length,
                    shrinkWrap: true,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width / 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: const Text(
                    'Total',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 7,
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
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text(
                    '${totalValor.toStringAsFixed(totalValor.truncateToDouble() == totalValor ? 0 : totalValor.toString().split('.').last.length).replaceAll('.', ',')}€',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.black12,
            ),
            const SizedBox(height: 10),
            //? Add button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(154, 255, 255, 255)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 45,
                        color: Colors.black,
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Adicionar Item',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                  onPressed: () {
                    _addItemDialog();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
