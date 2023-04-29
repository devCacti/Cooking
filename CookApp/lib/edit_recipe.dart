// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/receita.dart';

//! Confirmation Dialog
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

void editingDialog(BuildContext context, Recipe toEditR) {
  //!Declaring all Variables
  String? foto = toEditR.foto;
  int id = toEditR.id;
  String nome = toEditR.nome;
  String desc = toEditR.descricao;
  List<String>? ings = toEditR.ingredientes;
  List<String>? ingsT = toEditR.ingTipo;
  List<double> ingsQ = toEditR.ingQuant!;
  List<String>? procs = toEditR.procedimento;
  double? tempo = toEditR.tempo;
  double? porcs = toEditR.porcoes;
  String? categ = toEditR.categoria;
  bool fav = toEditR.favorita;

  final _nameKey = GlobalKey<FormFieldState>();
  final _descKey = GlobalKey<FormFieldState>();
  final _ingsKey = GlobalKey<FormFieldState>();

  final TextEditingController _ingsController = TextEditingController();
  final TextEditingController _quantController = TextEditingController();

  String? ingsR;

  List<TextEditingController> hintControllers = List.generate(
    toEditR.ingQuant!.length,
    (_) => TextEditingController(text: toEditR.ingQuant![_].toStringAsFixed(0)),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          return showConfirmationDialog(context);
        },
        child: StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      'Editar: ${toEditR.nome}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 20,
                            ),
                            child: Column(
                              children: [
                                foto == null
                                    ? IconButton(
                                        icon: const Icon(
                                            Icons.image_not_supported),
                                        iconSize: 100,
                                        splashRadius: 65,
                                        color: Colors.grey,
                                        onPressed: () async {
                                          var image = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                          setState(() {
                                            foto = image?.path;
                                          });
                                        },
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(40),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                File(foto!),
                                                height: 100,
                                              ),
                                            ),
                                            Positioned(
                                              right: 10,
                                              top: 10,
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons.edit_outlined),
                                                onPressed: () async {
                                                  var image =
                                                      await ImagePicker()
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                  setState(() {
                                                    foto = image?.path;
                                                  });
                                                },
                                                tooltip: 'Mudar Foto',
                                                iconSize: 40,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: TextFormField(
                                    key: _nameKey,
                                    maxLength: 75,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Nome',
                                    ),
                                    initialValue: nome,
                                    onChanged: (String? value) {
                                      setState(
                                        () {
                                          if (value != null) {
                                            nome = value;
                                          }
                                        },
                                      );
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
                                  padding: const EdgeInsets.all(16),
                                  child: TextFormField(
                                    key: _descKey,
                                    maxLength: 500,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Descrição',
                                    ),
                                    initialValue: desc,
                                    onChanged: (String? value) {
                                      setState(
                                        () {
                                          if (value != null) {
                                            desc = value;
                                          }
                                        },
                                      );
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor insira uma descrição';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ings!.isEmpty
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: ings.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8, left: 16, right: 16),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[200],
                                            ),
                                            child: ListTile(
                                              onLongPress: () {
                                                setState(() {
                                                  ings.remove(ings[index]);
                                                  ingsT.remove(ingsT[index]);
                                                  ingsQ.remove(ingsQ[index]);
                                                });
                                              },
                                              title: Text(
                                                ings[index],
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                              trailing: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Semantics(
                                                    label: 'quantidade',
                                                    child: SizedBox(
                                                      width: 32,
                                                      height: 44,
                                                      child: TextField(
                                                        controller:
                                                            hintControllers[
                                                                index],
                                                        style: const TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 16,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        onChanged: (value) {
                                                          final newValue =
                                                              double.tryParse(
                                                                  value);
                                                          if (newValue !=
                                                              null) {
                                                            setState(() {
                                                              ingsQ[index] =
                                                                  newValue;
                                                            });
                                                          } else {
                                                            ingsQ[index] = 0;
                                                          }
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText: '0',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  DropdownButton<String>(
                                                    value: ingsT![index],
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
                                                    ].map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                      (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      },
                                                    ).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        ingsT[index] =
                                                            newValue!;
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
                            padding: const EdgeInsets.only(
                                right: 16, left: 16, top: 16),
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
                                    color: Colors.orange,
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        if (ingsR != null) {
                                          hintControllers.add(
                                            TextEditingController(text: '0'),
                                          );
                                          //* Parte principal
                                          ings.add(ingsR!);
                                          _ingsController.text = '';
                                          ingsR = '';

                                          //* Parte das opções
                                          ingsT!.add('g');
                                          ingsQ.add(0);
                                        }
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.maybePop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black54,
                            elevation: 2,
                          ),
                          child: const Text(
                            'Sair',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_nameKey.currentState != null) {
                              _nameKey.currentState!.validate();
                            }
                            if (_descKey.currentState != null) {
                              _descKey.currentState!.validate();
                            }

                            if (nome.isNotEmpty && desc.isNotEmpty) {
                              editRecipeById(
                                id,
                                Recipe(
                                  id: id,
                                  foto: foto,
                                  nome: nome,
                                  descricao: desc,
                                  ingredientes: ings,
                                  ingTipo: ingsT,
                                  ingQuant: ingsQ,
                                  procedimento: toEditR.procedimento,
                                  tempo: toEditR.tempo,
                                  porcoes: toEditR.porcoes,
                                  categoria: toEditR.categoria,
                                  favorita: toEditR.favorita,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Guardar & Sair',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
