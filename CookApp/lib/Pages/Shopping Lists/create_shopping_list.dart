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

  ListClass list = ListClass();
  Color pickerColor = Colors.grey;
  int id = 0;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    id = await nextId();
    setState(() {
      list.id = id;
    });
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
                child: list.id != null
                    ? Column(
                        children: [
                          Text(
                            'ID: ${list.id}',
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Data: ${list.dataString}',
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
                  backgroundColor:
                      MaterialStateProperty.all(Colors.white.withOpacity(0.4)),
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
              //Name text box
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Nome da Lista',
                ),
                onChanged: (value) {
                  setState(() {
                    list.nome = value;
                  });
                },
              ),

              //Space between text boxes (Name and Description)
              const SizedBox(height: 20),

              //Description text box
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Descrição da Lista',
                ),
                onChanged: (value) {
                  setState(() {
                    list.descricao = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              IconButton(
                iconSize: 60,
                onPressed: () async {
                  list.color = pickerColor;
                  await saveList(list).then((value) {
                    Navigator.pop(context);
                  });
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
    );
  }
}
