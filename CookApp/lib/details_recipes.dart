import 'dart:io';

import 'package:flutter/material.dart';

void showBigDialog(
  BuildContext context,
  String? foto,
  String name,
  String desc,
  String ings,
  String prep,
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
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 75, right: 75),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: foto == null
                            ? const Icon(
                                Icons.warning,
                                size: 50,
                                color: Colors.red,
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
                        Text(
                          ings,
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
                          'Tempo de preparação:  ',
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
                          prep,
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
