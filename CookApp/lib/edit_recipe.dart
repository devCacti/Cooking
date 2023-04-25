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

  Recipe edited = Recipe(
    id: id,
    nome: nome,
    descricao: desc,
    ingredientes: ings,
    ingTipo: ingsT,
    ingQuant: ingsQ,
    procedimento: procs,
    tempo: tempo,
    porcoes: porcs,
    categoria: categ,
    favorita: fav,
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
                      toEditR.nome,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          foto == null
                              ? IconButton(
                                  icon: const Icon(Icons.image_not_supported),
                                  onPressed: () {},
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    right: 40,
                                    left: 40,
                                    bottom: 10,
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(foto!),
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        top: 10,
                                        child: IconButton(
                                          icon: const Icon(Icons.edit_outlined),
                                          onPressed: () async {
                                            var image = await ImagePicker()
                                                .pickImage(
                                                    source:
                                                        ImageSource.gallery);
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
                                  )),
                        ],
                      ),
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
