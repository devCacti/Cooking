import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class DetailsForm extends StatefulWidget {
  final String? foto;
  final String name;
  final String desc;
  final List<String>? ings;
  final List<String> ingsOpts;
  final List<double> ingsQuant;
  final List<String>? prep;
  final double? prepTime;
  final double? porcoes;
  final String category;

  const DetailsForm({
    required this.foto,
    required this.name,
    required this.desc,
    required this.ings,
    required this.ingsOpts,
    required this.ingsQuant,
    required this.prep,
    required this.prepTime,
    required this.porcoes,
    required this.category,
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
        title: const Text('Miau'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.name,
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
                    padding: const EdgeInsets.only(left: 55, right: 55),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: widget.foto == null
                          ? const Icon(
                              Icons.image_not_supported,
                              size: 100,
                              color: Colors.grey,
                            )
                          : Image.file(
                              File(widget.foto!),
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
                        widget.desc,
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
                      widget.ings!.isEmpty
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
                                itemCount: widget.ings!.length,
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
                                          widget.ings![index],
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              widget.ingsQuant[index]
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
                                              widget.ingsOpts[index],
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
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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
                          child: widget.prep!.isEmpty
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
                                  itemCount: widget.prep!.length,
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
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            widget.prep![index],
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          index < widget.prep!.length - 1
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
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.prepTime!.toInt().toString()} min',
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
                        widget.porcoes!.toInt().toString(),
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
                        widget.category,
                        style: const TextStyle(
                          fontSize: 22,
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
      floatingActionButton: Align(
        alignment: FractionalOffset.bottomCenter,
        child: SpeedDial(
          icon: Icons.menu,
          buttonSize: 60.0,
          visible: true,
          closeManually: false,
          children: [
            SpeedDialChild(
              child: const Icon(
                Icons.list,
                size: 35,
              ),
              label: 'Lista de compras',
              onTap: (null),
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
        ),
      ),
    );
  }
}
