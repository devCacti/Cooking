import 'dart:io';

import 'package:flutter/material.dart';

void showBigDialog(
  BuildContext context,
  String? foto,
  String name,
  String desc,
  List<String>? ings,
  List<String> ingsOpts,
  List<double> ingsQuant,
  String? prep,
  double? prepTime,
  double? porcoes,
  String category,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 120, right: 120),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: foto == null
                            ? const Icon(
                                Icons.image_not_supported,
                                size: 100,
                                color: Colors.grey,
                              )
                            : Image.file(
                                File(foto),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Descrição:\n',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          desc,
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.black38,
                      indent: 20,
                      endIndent: 20,
                      height: 1,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Ingredientes:\n',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        ings!.isEmpty
                            ? const Text(
                                'Nenhum ingrediente',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                height: ings.length * 65,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: ings.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black12,
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            ings[index],
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                ingsQuant[index]
                                                    .toStringAsFixed(2)
                                                    .replaceAll(
                                                        RegExp(r'\.0+$'), ''),
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                ingsOpts[index],
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.black38,
                      indent: 20,
                      endIndent: 20,
                      height: 1,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        const Text(
                          'Tempo de preparação:\n',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${prepTime!.toInt().toString()} min',
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.black38,
                      indent: 20,
                      endIndent: 20,
                      height: 1,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Porções:  ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          porcoes!.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Icon(Icons.person),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.black38,
                      indent: 20,
                      endIndent: 20,
                      height: 1,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Procedimento:\n',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          prep ?? 'Indisponível',
                          style: const TextStyle(
                            fontSize: 22,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      color: Colors.black38,
                      indent: 20,
                      endIndent: 20,
                      height: 1,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Categoria:  ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Fechar',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
