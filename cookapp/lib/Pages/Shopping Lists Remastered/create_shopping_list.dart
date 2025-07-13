import 'dart:developer' as developer;

import 'package:cookapp/Classes/Shopping/list_store.dart';
import 'package:cookapp/Classes/Shopping/shopping_list.dart';
import 'package:cookapp/Classes/snackbars.dart';
import 'package:flutter/material.dart';
//import 'dart:developer' as developer;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CreateList extends StatefulWidget {
  const CreateList({super.key});

  @override

  // ignore: library_private_types_in_public_api
  _CreateListState createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  // text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ShoppingList list = ShoppingList(
    Id: UniqueKey().toString(),
    Name: '',
    Description: '',
    Store: null,
    ListItems: [],
    Detailed: false,
    ListColor: Colors.grey,
    CreatedAt: DateTime.now(),
    UpdatedAt: DateTime.now(),
  );

  // Option selected in the dropdown
  // List of stores
  List<String> stores = ["Escolha uma Loja"];

  //New Store Name
  String newStore = '';
  String store = 'Escolha uma Loja';

  Color get pickerColor => list.ListColor ?? Colors.grey;
  int id = 0;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    //? if the list is not updated, change from null to false to avoid errors
    await ListStore.load().then((value) {
      setState(() {
        stores = value.map((store) => store.Name).toList();
        if (stores.isEmpty) {
          stores = ["Escolha uma Loja"];
        } else {
          stores.insert(0, "Escolha uma Loja");
        }
      });
      developer.log("Stores loaded: $stores");
    }).catchError((error) {
      developer.log("Error loading stores: $error");
      // ignore: use_build_context_synchronously
      showSnackbar(context, 'Erro ao carregar lojas: $error', type: SnackBarType.error);
    });
  }

  void changeColor(Color color) {
    setState(() => list.ListColor = color);
  }

  void pop() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Lista'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              //Body of the creating of a new shopping list
              mainAxisAlignment: MainAxisAlignment.center,
              //Nome da lista
              //Descrição da lista
              //Botão de criar lista
              //Data de criação da lista (Não editavel pelo utilizador mas sim automatico correspondente ao dia que a pessoa está a criar a lista)

              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        Text(
                          'ID: ${list.Id}',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Data: ${list.CreatedAt?.toLocal().toIso8601String().split('T').first}',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )),
                //Color picker

                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white70),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 45,
                        color: pickerColor,
                      ),
                      const SizedBox(width: 20),
                      const Text('Escolher Cor', style: TextStyle(fontSize: 20, color: Colors.black)),
                    ],
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: pickerColor,
                              onColorChanged: changeColor,
                              pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Escolher'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                          labelText: 'Loja',
                        ),
                        items: stores.map((String value) {
                          developer.log("Stores: $value");
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: "Escolha uma Loja",
                        onChanged: (value) {
                          setState(() {
                            store = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    //Button to add a new store
                    IconButton(
                      iconSize: 50,
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Adicionar Loja',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String newStore = '';
                            void refresh() {
                              setState(() {
                                setState(() {});
                                Navigator.pop(context);
                              });
                            }

                            return StatefulBuilder(builder: (context, setState) {
                              return AlertDialog(
                                title: const Text('Adicionar Loja'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                                        labelText: 'Nome da Loja',
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          newStore = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: newStore.isEmpty || stores.contains(newStore)
                                          ? null
                                          : () {
                                              if (newStore.isNotEmpty) {
                                                ListStore.addStore(ListStore(Name: newStore)).then((_) {
                                                  refresh();
                                                  initializeData();
                                                }).catchError((error) {
                                                  // ignore: use_build_context_synchronously
                                                  showSnackbar(context, 'Erro ao adicionar loja: $error', type: SnackBarType.error);
                                                });
                                              }
                                            },
                                      child: const Text('Adicionar Loja'),
                                    ),
                                  ],
                                ),
                              );
                            });
                          },
                        );
                      },
                      icon: const Icon(Icons.edit_note_rounded, color: Colors.greenAccent),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                //Name text box
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                          labelText: 'Nome da Lista',
                        ),
                        onChanged: (value) {
                          setState(() {
                            list.Name = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor insira um nome';
                          }
                          return null;
                        },
                      ),

                      //Space between text boxes (Name and Description)
                      const SizedBox(height: 20),

                      //Description text box
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                          labelText: 'Descrição da Lista',
                        ),
                        onChanged: (value) {
                          setState(() {
                            list.Description = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                //Simple or Detailed list switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Detalhada', style: TextStyle(fontSize: 20)),
                    Spacer(),
                    Switch(
                      value: list.Detailed,
                      onChanged: (value) {
                        setState(() {
                          list.Detailed = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(50),
                  child: IconButton(
                    iconSize: 60,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        list.ListColor = pickerColor;
                        list.Store = store == "Escolha uma Loja" ? null : ListStore(Name: store);
                        ShoppingList.addList(list).then((_) {
                          pop();
                        }).catchError((error) {
                          // ignore: use_build_context_synchronously
                          showSnackbar(context, 'Erro ao criar lista: $error', type: SnackBarType.error);
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
