import 'package:cookapp/Classes/lista_compra.dart';
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

  ListClass list = ListClass(id: 0, nome: '');

  // Option selected in the dropdown
  String loja = "Nova Loja";
  // List of stores
  List<String> lojas = ["Nova Loja"];

  //New Store Name
  String newStore = '';

  Color pickerColor = Colors.grey;
  int id = 0;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    id = await nextId();
    Loja lojaInstance = Loja(nome: 'Nova Loja');
    List<Loja> lojasTemp = await lojaInstance.load();
    list.data = list.setData();
    setState(() {
      list.id = id;

      for (var loja in lojasTemp) {
        if (loja.nome != 'Nova Loja' && loja.nome.isNotEmpty) {
          lojas.add(loja.nome);
          //developer.log('Loja: ${loja.nome}');
        }
      }

      list.detalhada ??= false;
    });

    //? if the list is not updated, change from null to false to avoid errors
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
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
                  child: list.id != 0
                      ? Column(
                          children: [
                            Text(
                              'ID: ${list.id}',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'Data: ${list.data}',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )
                      :
                      //Loading ICon
                      const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        ),
                ),
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
                //Stores dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                    labelText: 'Loja',
                  ),
                  items: lojas.map((String value) {
                    ////developer.log("Stores: $value");
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: loja == 'Escolher Loja' ? null : loja,
                  onChanged: (value) {
                    if (value == 'Nova Loja') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String newStore = '';
                          void refresh() {
                            setState(() {});
                            Navigator.pop(context);
                          }

                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: const Text('Adicionar Loja'),
                                content: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      newStore = value;
                                    });
                                  },
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: lojas.contains(newStore) || newStore.isEmpty
                                        ? null
                                        : () async {
                                            if (lojas.contains(newStore)) {
                                              return;
                                            }
                                            Loja lojaInstance = Loja(nome: newStore);
                                            await lojaInstance.save();
                                            setState(() {
                                              lojas.add(newStore);
                                              loja = newStore;
                                            });
                                            // ignore: use_build_context_synchronously
                                            refresh();
                                          },
                                    child: const Text('Adicionar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    } else {
                      setState(() {
                        loja = value!;
                      });
                    }
                  },
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
                            list.nome = value;
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
                            list.descricao = value;
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
                    SizedBox(
                      // Width of the screen divided by 3
                      width: MediaQuery.of(context).size.width / 4,
                      child: const Text('Simples', style: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(
                      // Width of the screen divided by 3
                      width: MediaQuery.of(context).size.width / 4,
                      child: Switch(
                        value: list.detalhada!,
                        onChanged: (value) {
                          setState(() {
                            list.detalhada = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: const Text('Detalhada', style: TextStyle(fontSize: 20)),
                    )
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
                        list.color = pickerColor;
                        saveList(list).then((value) {
                          pop();
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
