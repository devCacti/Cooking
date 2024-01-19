import 'package:cooking_app/Classes/lista_compra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CreateList extends StatefulWidget {
  const CreateList({Key? key}) : super(key: key);

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

  String loja = "Escolher Loja";
  List<String> lojas = [];

  Color pickerColor = Colors.grey;
  int id = 0;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    id = await nextId();
    Loja lojaInstance = Loja(nome: 'Escolher Loja');
    List<Loja> lojasTemp = await lojaInstance.load();
    list.data = list.setData();
    setState(() {
      list.id = id;

      for (var loja in lojasTemp) {
        lojas.add(loja.nome);
      }

      lojas.add('Nova Loja');
    });

    //? if the list is not updated, change from null to false to avoid errors
    if (list.detalhada == null) {
      setState(() {
        list.detalhada = false;
      });
    }
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
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
          padding: const EdgeInsets.all(20),
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
                    backgroundColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.9)),
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
                      const Text('Escolher Cor',
                          style: TextStyle(fontSize: 20, color: Colors.black)),
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
                              child: const Text('Got it'),
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
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Escolher Loja',
                  ),
                  value: loja == 'Escolher Loja'
                      ? null
                      : loja, // set value to null if loja is 'Escolher Loja'
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        if (value != 'Nova Loja') {
                          loja = value;
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Nova Loja'),
                                content: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    labelText: 'Nome da Loja',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      loja = value;
                                    });
                                  },
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Criar'),
                                    onPressed: () async {
                                      Loja lojaInstance = Loja(nome: loja);
                                      await lojaInstance.save();
                                      List<Loja> lojasTemp =
                                          await lojaInstance.load();
                                      setState(() {
                                        lojas = [];
                                        for (var loja in lojasTemp) {
                                          lojas.add(loja.nome);
                                        }
                                        lojas.add('Nova Loja');
                                        loja = 'Escolher Loja';
                                      });
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        // set loja to 'Escolher Loja' if value is null
                        loja = 'Escolher Loja';
                      }
                    });
                  },
                  items: lojas.map((String store) {
                    return DropdownMenuItem(
                      value: store,
                      child: Text(store),
                    );
                  }).toList(),
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
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
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
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
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
                      child:
                          const Text('Simples', style: TextStyle(fontSize: 20)),
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
                      child: const Text('Detalhada',
                          style: TextStyle(fontSize: 20)),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                IconButton(
                  iconSize: 60,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      list.color = pickerColor;
                      await saveList(list).then((value) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.greenAccent,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
