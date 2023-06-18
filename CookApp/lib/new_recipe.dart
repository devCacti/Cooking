import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'receita.dart';

class NewRecipeForm extends StatefulWidget {
  const NewRecipeForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewRecipeFormState createState() => _NewRecipeFormState();
}

class _NewRecipeFormState extends State<NewRecipeForm> {
  //? Variaveis para guardar no ficheiro
  Recipe? novaReceita; //? Variável principal

  int id = 1;
  XFile? _image;
  String? nomeR; //* Nome da receita
  String? descR; //* Decrição da receita
  String? ingsR; //* Ingredientes da receita
  String? procR; //* Procedimento da receita
  double tempoCozi = 0;
  double porcoes = 0;
  String _selectedValue = 'Geral';
  bool? favorita = false;

  //*Variável para validar (Não utilizada na gravação de dados)
  bool? validate = false;

  //*Nome
  final _nameKey = GlobalKey<FormFieldState>();

  //*Descrição
  final _descKey = GlobalKey<FormFieldState>();

  //*Ingredientes
  final _ingsKey = GlobalKey<FormFieldState>();
  final TextEditingController _ingsController = TextEditingController();
  List<String> ingredientes = [];
  List<String> ingsOpts = [];
  List<double> ingsQaunt = [];

  //*Confecionamento
  final _procKey = GlobalKey<FormFieldState>();
  final TextEditingController _procController = TextEditingController();
  List<String> procedimentos = [];

  final TextEditingController _tempoController = TextEditingController(
    text: '0',
  );
  final TextEditingController _porcoesController = TextEditingController(
    text: '0',
  );

  List<TextEditingController> procsControllers = [];

  Future<bool> showConfirmationDialog(BuildContext context) async {
    bool confirm = false;
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            brightness: Brightness.dark,
            textTheme: const TextTheme(
              titleMedium: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          child: CupertinoAlertDialog(
            title: const Text(
              'Sair?',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Esta ação é irrevertível.\nQualquer progresso feito será perdido!',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  confirm = true;
                  Navigator.pop(context);
                },
                child: const Text('Sim'),
              ),
            ],
          ),
        );
      },
    );
    return confirm;
  }

  Future<void> _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    id = await getNextId();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return showConfirmationDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nova Receita'),
          centerTitle: true,
          shadowColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 100.0,
                    right: 100.0,
                    top: 32,
                    bottom: 32,
                  ),
                  child: _image == null
                      ? IconButton(
                          icon: const Icon(Icons.camera_alt_outlined),
                          iconSize: 75,
                          onPressed: _getImage,
                          tooltip: 'Escolher Foto',
                        )
                      : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: _getImage,
                                tooltip: 'Mudar Foto',
                                iconSize: 40,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                ),
                //!Começo
                Padding(
                  padding: const EdgeInsets.only(right: 32, left: 32),
                  child: TextFormField(
                    key: _nameKey,
                    maxLength: 75,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      hintText: 'Escreva um nome',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _nameKey.currentState!.validate();
                      nomeR = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor insira um nome';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32, left: 32, top: 16, bottom: 12),
                  child: TextFormField(
                    key: _descKey,
                    maxLines: null,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      hintText: 'Escreva uma descrição',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _descKey.currentState!.validate();
                      descR = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor insira uma descrição';
                      }
                      return null;
                    },
                  ),
                ),
                const Divider(
                  indent: 100,
                  endIndent: 100,
                  height: 1,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ingredientes.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhum ingrediente',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ingredientes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[200],
                                  ),
                                  child: ListTile(
                                    onLongPress: () {
                                      setState(() {
                                        ingredientes.remove(ingredientes[index]);
                                        ingsOpts.remove(ingsOpts[index]);
                                        ingsQaunt.remove(ingsQaunt[index]);
                                      });
                                    },
                                    title: Text(
                                      ingredientes[index],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    trailing: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Semantics(
                                          label: 'quantidade',
                                          child: SizedBox(
                                            width: 32,
                                            height: 44,
                                            child: TextField(
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                              onChanged: (value) {
                                                final newValue = double.tryParse(value);
                                                if (newValue != null && newValue != ingsQaunt[index]) {
                                                  setState(() {
                                                    ingsQaunt[index] = newValue;
                                                  });
                                                } else {
                                                  ingsQaunt[index] = 0;
                                                }
                                              },
                                              keyboardType: TextInputType.number,
                                              decoration: const InputDecoration(
                                                hintText: '0',
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        DropdownButton<String>(
                                          value: ingsOpts[index],
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 20,
                                          ),
                                          items: <String>[
                                            'Kg',
                                            'g',
                                            'L',
                                            'mL',
                                            'unid.',
                                            'colh.',
                                            'chav.',
                                          ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              ingsOpts[index] = newValue!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32, left: 32, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          key: _ingsKey,
                          controller: _ingsController,
                          decoration: const InputDecoration(
                            labelText: 'Ingredientes',
                            hintText: 'Insira um ingrediente',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            ingsR = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 0,
                        child: IconButton(
                          tooltip: 'Adicionar',
                          splashRadius: 35,
                          iconSize: 50,
                          splashColor: Colors.black12,
                          color: Colors.green,
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              if (ingsR != '') {
                                //* Parte principal
                                ingredientes.add(ingsR!);
                                _ingsController.text = '';
                                ingsR = '';

                                //* Parte das opções
                                ingsOpts.add('g');
                                ingsQaunt.add(0);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  indent: 35,
                  endIndent: 35,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: procedimentos.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhum passo',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: procedimentos.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8,
                                  left: 16,
                                  right: 16,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Passo N.º ${index + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: procsControllers[index],
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                      decoration: const InputDecoration(
                                        label: Text('Procedimento'),
                                      ),
                                      textAlign: TextAlign.justify,
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            procedimentos[index] = value;
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    IconButton(
                                      onPressed: index < 1
                                          ? null
                                          : () {
                                              String temp;
                                              setState(() {
                                                temp = procedimentos[index - 1];

                                                procedimentos[index - 1] = procedimentos[index];
                                                procedimentos[index] = temp;

                                                procsControllers[index - 1].text = procsControllers[index].text;
                                                procsControllers[index].text = temp;
                                              });
                                            },
                                      icon: const Icon(Icons.arrow_upward),
                                      tooltip: 'Mover para cima',
                                    ),
                                    IconButton(
                                      tooltip: 'Eliminar',
                                      icon: const Icon(
                                        Icons.delete_outlined,
                                        color: Colors.red,
                                      ),
                                      iconSize: 40,
                                      onPressed: () {
                                        showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Theme(
                                              data: ThemeData(
                                                brightness: Brightness.light,
                                                textTheme: const TextTheme(
                                                  titleMedium: TextStyle(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                              child: CupertinoAlertDialog(
                                                title: const Text('Eliminar?'),
                                                content: const Text('Deseja eliminar este procedimento permanentemente?'),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    isDefaultAction: true,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancelar'),
                                                  ),
                                                  CupertinoDialogAction(
                                                    isDestructiveAction: true,
                                                    onPressed: () {
                                                      setState(() {
                                                        procedimentos.remove(procedimentos[index]);
                                                        procsControllers.remove(procsControllers[index]);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Eliminar'),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      onPressed: index == procedimentos.length - 1
                                          ? null
                                          : () {
                                              String temp;
                                              setState(() {
                                                temp = procedimentos[index + 1];
                                                procedimentos[index + 1] = procedimentos[index];
                                                procedimentos[index] = temp;
                                                procsControllers[index + 1].text = procsControllers[index].text;
                                                procsControllers[index].text = temp;
                                              });
                                            },
                                      icon: const Icon(Icons.arrow_downward),
                                      tooltip: 'Mover para cima',
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    index < procedimentos.length - 1
                                        ? const Divider(
                                            thickness: 1,
                                            indent: 30,
                                            endIndent: 30,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32, left: 32, top: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          key: _procKey,
                          controller: _procController,
                          maxLines: null,
                          decoration: const InputDecoration(
                            labelText: 'Preparação',
                            hintText: 'Descreva o procedimento',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              procR = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 0,
                        child: IconButton(
                          tooltip: 'Adicionar',
                          splashRadius: 35,
                          iconSize: 50,
                          color: Colors.green,
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              if (procR != '') {
                                procedimentos.add(procR!);
                                _procController.text = '';
                                procsControllers.add(TextEditingController(text: procR));
                                procR = '';
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                //!Acaba
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Divider(
                    indent: 75,
                    endIndent: 75,
                    height: 2,
                    color: Colors.grey,
                  ),
                ),
                //! OUTRAS OPÇÕES (COMEÇO)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: Text(
                      'Outros detalhes',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                    left: 12,
                    bottom: 12,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 32, bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Tempo (Mins):',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                                height: 1,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: const SizedBox(
                                  width: 75,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                                height: 1,
                              ),
                              Semantics(
                                label: 'tempo',
                                child: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: TextField(
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                    textAlign: TextAlign.center,
                                    onChanged: (value) {
                                      final newValue = double.tryParse(value);
                                      if (newValue != null && newValue != tempoCozi) {
                                        setState(() {
                                          tempoCozi = newValue;
                                        });
                                      } else {
                                        tempoCozi = 0;
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: _tempoController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Porções:',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                                height: 1,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: const SizedBox(
                                  width: 75,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                                height: 1,
                              ),
                              Semantics(
                                label: 'porcao',
                                child: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: TextField(
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                    textAlign: TextAlign.center,
                                    onChanged: (value) {
                                      final newValue = double.tryParse(value);
                                      if (newValue != null && newValue != porcoes) {
                                        setState(() {
                                          porcoes = newValue;
                                        });
                                      } else {
                                        porcoes = 0;
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: _porcoesController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'Categoria:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                              height: 1,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: const SizedBox(
                                width: 75,
                                height: 1,
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                              height: 1,
                            ),
                            DropdownButton<String>(
                              value: _selectedValue,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                              ),
                              items: <String>['Geral', 'Bolos', 'Tartes', 'Sobremesas', 'Pratos'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedValue = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Favorita',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                                height: 1,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: const SizedBox(
                                  width: 75,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                                height: 1,
                              ),
                              Checkbox(
                                value: favorita,
                                onChanged: (value) {
                                  setState(() {
                                    favorita = value;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //! OUTRAS OPÇÕES (FIM)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 32,
                    bottom: 64,
                  ),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: IconButton(
                      //! Botão para guardar
                      icon: const Icon(Icons.save),
                      highlightColor: Colors.green[200],
                      tooltip: 'Guardar',
                      onPressed: () {
                        //Processo para fazer com que apareça a mensagem em todos os campos

                        try {
                          _nameKey.currentState!.validate();
                          _descKey.currentState!.validate();

                          //Certificação
                          validate = _nameKey.currentState!.validate() && _descKey.currentState!.validate();
                          if (validate == true) {
                            //! Processo que guarda a informação
                            final novaReceita = Recipe(
                              id: id,
                              foto: _image == null ? null : _image!.path,
                              nome: nomeR!,
                              descricao: descR!,
                              ingredientes: ingredientes,
                              ingTipo: ingsOpts,
                              ingQuant: ingsQaunt,
                              procedimento: procedimentos,
                              tempo: tempoCozi,
                              porcoes: porcoes,
                              categoria: _selectedValue,
                              favorita: favorita!,
                            );

                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'A receita foi guardada com sucesso.',
                                ),
                                action: SnackBarAction(label: 'OK', onPressed: () {}),
                              ),
                            );
                            saveRecipe(novaReceita);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Por favor insira um nome e uma descrição.',
                                ),
                                action: SnackBarAction(label: 'OK', onPressed: () {}),
                              ),
                            );
                          }
                        } catch (e) {
                          throw Exception('Não deu: $e');
                        }
                      },
                    ),
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
