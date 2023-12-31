import 'package:flutter/cupertino.dart';
import 'package:cooking_app/Classes/lista_compra.dart';
import 'package:flutter/material.dart';

class ViewList extends StatefulWidget {
  final int id;

  const ViewList({Key? key, required this.id}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewListState createState() => _ViewListState();
}

class _ViewListState extends State<ViewList> {
  ListClass list = ListClass(id: 0, nome: '');

  TextEditingController nomeController = TextEditingController(text: '');
  TextEditingController quantidadeController = TextEditingController(text: '');
  TextEditingController precoController = TextEditingController(text: '');

  bool allChecked = false;

  double get totalValor {
    double total = 0;
    for (var item in list.items!) {
      total += item.preco * item.quantidade;
    }
    return total;
  }

  //Init State to load everything
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    await loadListById(widget.id).then((value) {
      setState(() {
        list = value!;
      });
    });
  }

  bool get allItemsChecked {
    overwriteListById(list.id, list);
    for (var item in list.items!) {
      if (!item.checked) {
        return false;
      }
    }
    return true;
  }

  //? Add Item Dialog
  Future<void> _addItemDialog() {
    return showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Adicionar Item'),
          content: Column(
            children: [
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: nomeController,
                placeholder: 'Item',
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: quantidadeController,
                      placeholder: 'Quantidade',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CupertinoTextField(
                      controller: precoController,
                      placeholder: 'Preço',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancelar'),
              onPressed: () {
                nomeController.clear();
                quantidadeController.clear();
                precoController.clear();

                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Adicionar'),
              onPressed: () {
                if (nomeController.text != '' &&
                    nomeController.text.isNotEmpty) {
                  if (quantidadeController.text.isNotEmpty) {
                    //replace , with . if it exists
                    quantidadeController.text =
                        quantidadeController.text.replaceAll(',', '.');
                  }
                  list.addItem(
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
                overwriteListById(list.id, list);
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
              list.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            list.descricao == null
                ? const SizedBox()
                : Column(
                    children: [
                      Text(
                        list.descricao!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
            Text(
              list.data == null ? 'Sem Data' : list.data!,
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
                    value: allChecked,
                    onChanged: (value) {
                      setState(() {
                        allChecked = value!;
                        for (var item in list.items!) {
                          item.checked = value;
                        }
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
                  width: MediaQuery.of(context).size.width / 6,
                  child: const Text(
                    'Quant.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 6,
                  child: const Text(
                    'Valor',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
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
            list.items!.isEmpty
                //? If there are no items
                ? const Center(
                    child: Text('Sem Items'),
                  )
                //? If there are items
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //Checked
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 10,
                                child: Checkbox(
                                  value: list.items![index].checked,
                                  onChanged: (value) {
                                    setState(() {
                                      list.items![index].checked = value!;
                                      allChecked = allItemsChecked;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: Text(
                                  list.items![index].nome,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 6,
                                child: Text(
                                  // Avoiding x.0 values instead just x
                                  list.items![index].quantidade == 0
                                      ? '0'
                                      : list.items![index].quantidade
                                          .toStringAsFixed(list
                                                      .items![index].quantidade
                                                      .truncateToDouble() ==
                                                  list.items![index].quantidade
                                              ? 0
                                              : 2)
                                          .replaceAll('.', ','),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 6,
                                child: Text(
                                  list.items![index].preco == 0
                                      ? '0€'
                                      : '${list.items![index].preco.toStringAsFixed(2).replaceAll('.', ',')}€',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                    itemCount: list.items!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
            const SizedBox(height: 10),
            //? Divider
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.black12,
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
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
                  width: MediaQuery.of(context).size.width / 6,
                  child: const Text(
                    '0',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 6,
                  child: Text(
                    totalValor == 0
                        ? '0€'
                        : '${totalValor.toStringAsFixed(2).replaceAll('.', ',')}€',
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
                    backgroundColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.4)),
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
                      Text('Adicionar Item',
                          style: TextStyle(fontSize: 20, color: Colors.black)),
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
