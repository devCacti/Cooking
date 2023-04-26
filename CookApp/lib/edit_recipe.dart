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
            ))),
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
  List<double>? ingsQ = toEditR.ingQuant;
  List<String>? procs = toEditR.procedimento;
  double? tempo = toEditR.tempo;
  double? porcs = toEditR.porcoes;
  String? categ = toEditR.categoria;
  bool fav = toEditR.favorita;

  final _nameKey = GlobalKey<FormFieldState>();
  final _descKey = GlobalKey<FormFieldState>();

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
                          //!Gestão da foto principal
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
                            _nameKey.currentState!.validate();
                            _descKey.currentState!.validate();

                            bool validate = _nameKey.currentState!.validate() &&
                                _descKey.currentState!.validate();

                            if (nome.isNotEmpty && desc.isNotEmpty) {
                              editRecipeById(
                                id,
                                Recipe(
                                  id: id,
                                  foto: foto,
                                  nome: nome,
                                  descricao: desc,
                                  ingredientes: toEditR.ingredientes,
                                  ingTipo: toEditR.ingTipo,
                                  ingQuant: toEditR.ingQuant,
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
