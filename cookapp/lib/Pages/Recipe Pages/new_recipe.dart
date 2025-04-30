// ignore_for_file: deprecated_member_use

import 'package:cookapp/Settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../Functions/server_requests.dart';
import '../../Classes/recipes.dart';
import '../../Classes/ingredients.dart';

class NewRecipeForm extends StatefulWidget {
  final BuildContext context;
  const NewRecipeForm({super.key, required this.context});

  @override
  // ignore: library_private_types_in_public_api
  _NewRecipeFormState createState() => _NewRecipeFormState();
}

class _NewRecipeFormState extends State<NewRecipeForm> {
  //? Variaveis para guardar no ficheiro
  Recipe? novaReceita; //? Variável principal

  int id = 1;
  File? _imageFile; //? Recipe Image File
  String? nameR; //* Recipe Name
  String? descR; //* Recipe Description
  String? ingsR; //* Recipe Ingredients
  String? procR; //* Recipe Procedure
  double cookTime = 0;
  double portions = 0;
  String _selectedValue = 'Geral';
  bool? isPublic = false;

  //*Validation variable, only used to check if the recipe is valid
  bool? validate = false;

  //*Name
  final _nameKey = GlobalKey<FormFieldState>();

  //*Description
  final _descKey = GlobalKey<FormFieldState>();

  //*Ingredients
  final _ingsKey = GlobalKey<FormFieldState>();
  final TextEditingController _ingsController = TextEditingController();
  List<String> ingredients = [];
  List<String> ingsOpts = [];
  List<double> ingsQaunt = [];

  //*Confecionamento
  final _procKey = GlobalKey<FormFieldState>();
  final TextEditingController _procController = TextEditingController();
  List<String> procedimentos = [];

  final TextEditingController _tempoController =
      TextEditingController(text: '0');
  final TextEditingController _porcoesController =
      TextEditingController(text: '0');

  List<TextEditingController> procsControllers = [];

  Future<bool> showConfirmationDialog(BuildContext context) async {
    bool confirm = false;
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Sair?',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
            'Esta ação é irrevertível. Tudo o que tenha feito será perdido!',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                confirm = true;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
    return confirm;
  }

  Future<void> _getImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
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
          shadowColor: Colors.black54,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: 32,
                    bottom: 16,
                    //bottom: 32,
                  ),
                  child: _imageFile == null
                      ? Material(
                          elevation: 10,
                          shape: //const
                              CircleBorder(),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt_outlined),
                            iconSize: 75,
                            onPressed: _getImage,
                            tooltip: 'Escolher Foto',
                          ),
                        )
                      : Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _imageFile != null
                                  ? Image.file(_imageFile!)
                                  : const Icon(
                                      Icons.image_not_supported_rounded),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: _getImage,
                                tooltip: 'Mudar Foto',
                                iconSize: 40,
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 32, left: 32),
                  child: TextFormField(
                    key: _nameKey,
                    maxLength: 75,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      hintText: 'Escreva um nome',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    onChanged: (value) {
                      _nameKey.currentState!.validate();
                      nameR = value;
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
                  padding: const EdgeInsets.only(
                      right: 32, left: 32, top: 16, bottom: 12),
                  child: TextFormField(
                    key: _descKey,
                    maxLines: null,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      hintText: 'Escreva uma descrição',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
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
                const SizedBox(
                  height: 20,
                ),

                //* Ingredients
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: Text(
                      'Ingredientes',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                ingredients.isEmpty
                    ? Container()
                    : const Text(
                        'Toque e segure para eliminar um ingrediente',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ingredients.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhum ingrediente',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ingredients.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8, left: 24, right: 24),
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(25),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    onLongPress: () {
                                      showConfirmationDialog(context).then(
                                        (value) {
                                          if (value) {
                                            setState(() {
                                              ingredients.removeAt(index);
                                              ingsOpts.removeAt(index);
                                              ingsQaunt.removeAt(index);
                                            });
                                          }
                                        },
                                      );
                                    },
                                    title: Text(
                                      ingredients[index],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    trailing: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Semantics(
                                          label: 'quantidade',
                                          child: SizedBox(
                                            width: 32,
                                            height: 44,
                                            child: TextField(
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                              onChanged: (value) {
                                                final newValue =
                                                    double.tryParse(value);
                                                if (newValue != null &&
                                                    newValue !=
                                                        ingsQaunt[index]) {
                                                  setState(() {
                                                    ingsQaunt[index] = newValue;
                                                  });
                                                } else {
                                                  ingsQaunt[index] = 0;
                                                }
                                              },
                                              keyboardType:
                                                  TextInputType.number,
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
                            labelText: 'Novo Ingrediente',
                            hintText: 'Nome de um ingrediente',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
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
                        child: Material(
                          elevation: 5,
                          shape: const CircleBorder(),
                          child: IconButton(
                            tooltip: 'Adicionar',
                            splashRadius: 25,
                            iconSize: 40,
                            splashColor: Colors.black12,
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                try {
                                  if (ingsR != '') {
                                    //* Parte principal
                                    ingredients.add(ingsR!);
                                    _ingsController.text = '';
                                    ingsR = '';

                                    //* Parte das opções
                                    ingsOpts.add('g');
                                    ingsQaunt.add(0);
                                  }
                                } catch (e) {
                                  print('Erro: $e');
                                }
                              });
                            },
                          ),
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
                const SizedBox(
                  height: 20,
                ),
                //* Procedure
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: Text(
                      'Procedimento',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
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
                                fontSize: 16,
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
                                  left: 24,
                                  right: 24,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Passo N.º ${index + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: procsControllers[index],
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      decoration: const InputDecoration(
                                        label: Text('Procedimento'),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16)),
                                        ),
                                      ),
                                      maxLines: null,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //* Move up button
                                        IconButton(
                                          onPressed: index < 1
                                              ? null
                                              : () {
                                                  String temp;
                                                  setState(() {
                                                    temp = procedimentos[
                                                        index - 1];

                                                    procedimentos[index - 1] =
                                                        procedimentos[index];
                                                    procedimentos[index] = temp;

                                                    procsControllers[index - 1]
                                                            .text =
                                                        procsControllers[index]
                                                            .text;
                                                    procsControllers[index]
                                                        .text = temp;
                                                  });
                                                },
                                          icon: const Icon(Icons.arrow_upward),
                                          tooltip: 'Mover para cima',
                                        ),
                                        //* Delete button
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
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Eliminar',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    'Tem a certeza que deseja eliminar este passo?',
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                          'Cancelar'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          procedimentos
                                                              .removeAt(index);
                                                          procsControllers
                                                              .removeAt(index);
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      style: ButtonStyle(
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors.red),
                                                      ),
                                                      child: const Text('Sim'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        //* Move down button
                                        IconButton(
                                          onPressed: index ==
                                                  procedimentos.length - 1
                                              ? null
                                              : () {
                                                  String temp;
                                                  setState(() {
                                                    temp = procedimentos[
                                                        index + 1];
                                                    procedimentos[index + 1] =
                                                        procedimentos[index];
                                                    procedimentos[index] = temp;
                                                    procsControllers[index + 1]
                                                            .text =
                                                        procsControllers[index]
                                                            .text;
                                                    procsControllers[index]
                                                        .text = temp;
                                                  });
                                                },
                                          icon:
                                              const Icon(Icons.arrow_downward),
                                          tooltip: 'Mover para cima',
                                        ),
                                      ],
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
                //* Procedure
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
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
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
                        child: Material(
                          elevation: 5,
                          shape: const CircleBorder(),
                          child: IconButton(
                            tooltip: 'Adicionar',
                            splashRadius: 35,
                            iconSize: 40,
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                try {
                                  if (procR != '') {
                                    procedimentos.add(procR!);
                                    _procController.text = '';
                                    procsControllers.add(
                                        TextEditingController(text: procR));
                                    procR = '';
                                  }
                                } catch (e) {
                                  print('Erro: $e');
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  indent: 75,
                  endIndent: 75,
                  height: 2,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 25,
                ),
                //* Other options
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: Text(
                      'Outros detalhes',
                      style: TextStyle(
                        fontSize: 20,
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: const Text(
                                'Tempo [min]',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                    height: 1,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                    child: const SizedBox(
                                      width: 50,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                    height: 1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 48,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 48,
                                    child: Semantics(
                                      label: 'tempo',
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          final newValue =
                                              double.tryParse(value);
                                          if (newValue != null &&
                                              newValue != cookTime) {
                                            setState(() {
                                              cookTime = newValue;
                                            });
                                          } else {
                                            cookTime = 0;
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: const Text(
                                'Porções',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                    height: 1,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                    child: const SizedBox(
                                      width: 50,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                    height: 1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 48,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 48,
                                    child: Semantics(
                                      label: 'porcao',
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          final newValue =
                                              double.tryParse(value);
                                          if (newValue != null &&
                                              newValue != portions) {
                                            setState(() {
                                              portions = newValue;
                                            });
                                          } else {
                                            portions = 0;
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: const Text(
                                'Categoria',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                    height: 1,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                    child: const SizedBox(
                                      width: 50,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                    height: 1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: DropdownButton<String>(
                                value: _selectedValue,
                                style: TextStyle(
                                  fontSize: 16.8,
                                  color: themeNotifier.value == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                items: <String>[
                                  'Geral',
                                  'Bolos',
                                  'Tartes',
                                  'Sobremesas',
                                  'Pratos'
                                ].map<DropdownMenuItem<String>>((String value) {
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
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: const Text(
                                'Pública',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                    height: 1,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                    child: const SizedBox(
                                      width: 50,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                    height: 1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Switch(
                                value: isPublic!,
                                onChanged: (value) {
                                  setState(() {
                                    isPublic = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 32,
                    bottom: 48,
                  ),
                  child: Material(
                    elevation: 5,
                    shape: const CircleBorder(),
                    child: IconButton(
                      //! Save Button
                      icon: const Icon(
                        Icons.cloud_upload_outlined,
                        shadows: [Shadow(color: Colors.black)],
                      ),
                      iconSize: 60,
                      tooltip: 'Guardar',
                      onPressed: () {
                        //Process of showing the warning on the fields

                        try {
                          _nameKey.currentState!.validate();
                          _descKey.currentState!.validate();

                          //Verification
                          validate = _nameKey.currentState!.validate() &&
                              _descKey.currentState!.validate();
                          if (validate == true) {
                            //! TODO: Finish Changing the Recipe Creation Process
                            //* What?
                            //? Process of creating the Recipe
                            final List<IngBridge> bridges = [];
                            final List<Ingredient> ings = [];

                            // Insert into the ings list
                            for (int i = 0; i < ingredients.length; i++) {
                              ings.add(
                                Ingredient(
                                  id: "",
                                  name: ingredients[i],
                                  unit: ingsOpts[i],
                                ),
                              );
                            }

                            // Sending ingredients to the server for creation
                            newIngredients(ings).then((ingIds) {
                              // Insert into the bridges list
                              for (int i = 0; i < ingredients.length; i++) {
                                bridges.add(
                                  IngBridge(
                                    id: ingIds[i],
                                    ingredient: ings[i].id,
                                    amount: ingsQaunt[i],
                                  ),
                                );
                              }
                              // Using a new type of class to send the data to the server
                              RecipeC(
                                image: _imageFile,
                                title: nameR!,
                                description: descR!,
                                ////ingTipo: ingsOpts,
                                ingramounts: ingsQaunt,
                                steps: procedimentos,
                                time: cookTime,
                                portions: portions,
                                ////type: _selectedValue,
                                isPublic: isPublic ?? false,
                                ingredientIds: ingIds,
                              ).send().then((value) {
                                if (value) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'A receita foi guardada com sucesso.',
                                      ),
                                      action: SnackBarAction(
                                          label: 'OK',
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                          }),
                                    ),
                                  );

                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      //backgroundColor:
                                      //themeNotifier.value == ThemeMode.dark
                                      //    ? Colors.black54
                                      //    : Colors.white54,
                                      behavior: SnackBarBehavior.floating,
                                      content: const Text(
                                        'Não foi possível guardar a receita!',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      action: SnackBarAction(
                                          label: 'OK',
                                          textColor: Colors.red,
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                          }),
                                    ),
                                  );
                                }
                              });
                            });
                            // This is an else of a different if
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                //backgroundColor:
                                //    themeNotifier.value == ThemeMode.dark
                                //        ? Colors.black54
                                //        : Colors.white54,
                                behavior: SnackBarBehavior.floating,
                                content: const Text(
                                  'Insira um nome e uma descrição.',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                action: SnackBarAction(
                                    label: 'OK',
                                    textColor: Colors.red,
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }),
                              ),
                            );
                          }
                        } catch (e) {
                          throw Exception('Falha na criação da Receita: $e');
                        }
                      },
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
