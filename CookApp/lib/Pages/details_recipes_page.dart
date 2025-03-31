import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../Classes/receita.dart';

class DetailsForm extends StatefulWidget {
  final Recipe detailRecipe;
  final bool? isEdit;

  const DetailsForm({
    required this.detailRecipe,
    this.isEdit,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DetailsFormState createState() => _DetailsFormState();
}

class _DetailsFormState extends State<DetailsForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Detalhes da receita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.detailRecipe.nome,
              style: const TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 55, right: 55),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: widget.detailRecipe.foto == null
                          ? const Icon(
                              Icons.image_not_supported,
                              size: 100,
                              color: Colors.grey,
                            )
                          : Image.file(
                              File(widget.detailRecipe.foto!),
                            ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Descrição:\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        widget.detailRecipe.descricao,
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
                          fontSize: 28,
                        ),
                      ),
                      widget.detailRecipe.ingredientes!.isEmpty
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
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    widget.detailRecipe.ingredientes!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black12,
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          widget.detailRecipe
                                              .ingredientes![index],
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              widget.detailRecipe.ingQuant !=
                                                      null
                                                  ? widget.detailRecipe
                                                      .ingQuant![index]
                                                      .toStringAsFixed(2)
                                                      .replaceAll(
                                                          RegExp(r'\.0+$'), '')
                                                  : '',
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              widget
                                                  .detailRecipe.ingTipo![index],
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
                  const Text(
                    'Preparação',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: widget.detailRecipe.procedimento!.isEmpty
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
                                  itemCount:
                                      widget.detailRecipe.procedimento!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8, left: 16, right: 16),
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
                                            height: 20,
                                          ),
                                          Text(
                                            widget.detailRecipe
                                                .procedimento![index],
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          index <
                                                  widget
                                                          .detailRecipe
                                                          .procedimento!
                                                          .length -
                                                      1
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
                    ],
                  ),
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
                        'Tempo de cozedura:\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.detailRecipe.tempo.toInt().toString()} min',
                        style: const TextStyle(
                          fontSize: 24,
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
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.detailRecipe.porcoes.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 24,
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
                        widget.detailRecipe.categoria,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
      //Bottom app bar with a radial menu, the button should be a circle in the center
      //of the screen
      floatingActionButton: widget.isEdit == true
          ? SpeedDial(
              icon: Icons.menu,
              visible: true,
              closeManually: false,
              children: [
                SpeedDialChild(
                  child: const Icon(
                    Icons.list,
                    size: 35,
                  ),
                  label: 'Lista de compras',
                  onTap: null,
                ),
                SpeedDialChild(
                  child: const Icon(
                    Icons.edit,
                    size: 35,
                  ),
                  label: 'Editar receita',
                ),
                SpeedDialChild(
                  child: const Icon(
                    Icons.delete,
                    size: 35,
                  ),
                  label: 'Eliminar receita',
                ),
              ],
            )
          : null,
    );
  }
}
