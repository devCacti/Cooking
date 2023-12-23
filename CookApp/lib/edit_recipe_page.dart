import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Classes/receita.dart';
import 'Functions/show_conf_dialog.dart';

class EditForm extends StatefulWidget {
  final Recipe toEditR;

  const EditForm({
    required this.toEditR,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  Recipe? toEditR; //receita a editar substitui o toEditR que é inacessível
  late String? foto;
  late int id;
  late String nome;
  late String desc;
  late List<String>? ings;
  late List<String>? ingsT;
  late List<double>? ingsQ;
  late List<String>? procs;
  late double? tempo;
  late double? porcs;
  late String? categ;
  late bool fav;

  late final TextEditingController _tempoController;
  late final TextEditingController _porcsController;

  @override
  void initState() {
    super.initState();
    toEditR = widget.toEditR;
    foto = widget.toEditR.foto;
    id = widget.toEditR.id;
    nome = widget.toEditR.nome;
    desc = widget.toEditR.descricao;
    ings = widget.toEditR.ingredientes;
    ingsT = widget.toEditR.ingTipo;
    ingsQ = widget.toEditR.ingQuant!;
    procs = widget.toEditR.procedimento;
    tempo = widget.toEditR.tempo;
    porcs = widget.toEditR.porcoes;
    categ = widget.toEditR.categoria;
    fav = widget.toEditR.favorita;
    //String? _selectedValue = categ;

    _tempoController = TextEditingController(text: tempo!.toStringAsFixed(0));
    _porcsController = TextEditingController(text: porcs!.toStringAsFixed(0));
  }

  //!Declaring all Variables
  final _nameKey = GlobalKey<FormFieldState>();
  final _descKey = GlobalKey<FormFieldState>();
  final _ingsKey = GlobalKey<FormFieldState>();
  final _procKey = GlobalKey<FormFieldState>();

  final TextEditingController _ingsController = TextEditingController();
  //?final TextEditingController _quantController = TextEditingController();

  final TextEditingController _procController = TextEditingController();

  String? ingsR;
  String procR = '';

  Color cancelColor = Colors.white;
  Color saveColor = Colors.white;

  late List<TextEditingController> hintControllers = List.generate(
    toEditR!.ingQuant!.length,
    (_) =>
        TextEditingController(text: toEditR!.ingQuant![_].toStringAsFixed(0)),
  );

  late List<TextEditingController> procsControllers = List.generate(
    toEditR!.procedimento!.length,
    (_) => TextEditingController(text: toEditR!.procedimento![_]),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return showConfDialog(context);
      },
      child: StatefulBuilder(
        builder: (context, setState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Editar Receita',
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  if (await showConfDialog(context)) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    toEditR!.nome,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
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
                                      icon:
                                          const Icon(Icons.image_not_supported),
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
                                      padding: const EdgeInsets.all(30),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              File(foto!),
                                              height: 200,
                                            ),
                                          ),
                                          Positioned(
                                            right: 10,
                                            top: 10,
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.edit_outlined),
                                              onPressed: () async {
                                                var image = await ImagePicker()
                                                    .pickImage(
                                                        source: ImageSource
                                                            .gallery);
                                                setState(() {
                                                  foto = image?.path;
                                                });
                                              },
                                              tooltip: 'Mudar Foto',
                                              iconSize: 40,
                                              color: Colors.green,
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
                                padding: const EdgeInsets.only(
                                    top: 16, right: 16, left: 16),
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
                        const Divider(
                          indent: 40,
                          endIndent: 40,
                          color: Colors.black,
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
                                    itemCount: ings!.length,
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
                                                ings!.remove(ings![index]);
                                                ingsT!.remove(ingsT![index]);
                                                ingsQ!.remove(ingsQ![index]);
                                                hintControllers.removeAt(index);
                                              });
                                            },
                                            title: Text(
                                              ings![index],
                                              style:
                                                  const TextStyle(fontSize: 18),
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
                                                        if (newValue != null) {
                                                          setState(() {
                                                            ingsQ![index] =
                                                                newValue;
                                                          });
                                                        } else {
                                                          ingsQ![index] = 0;
                                                        }
                                                      },
                                                      keyboardType:
                                                          TextInputType.number,
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
                                                      DropdownMenuItem<String>>(
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
                                                      ingsT![index] = newValue!;
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
                                  color: Colors.green,
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      if (ingsR != null) {
                                        hintControllers.add(
                                          TextEditingController(text: '0'),
                                        );
                                        //* Parte principal
                                        ings!.add(ingsR!);
                                        _ingsController.text = '';
                                        ingsR = '';

                                        //* Parte das opções
                                        ingsT!.add('g');
                                        ingsQ!.add(0);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          indent: 40,
                          endIndent: 40,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: procs!.isEmpty
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: procs!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16,
                                          left: 16,
                                          right: 16,
                                          top: 24,
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
                                              controller:
                                                  procsControllers[index],
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
                                                    procs![index] = value;
                                                  },
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                //* Botões:
                                                //* Mover para cima
                                                //* Eliminar
                                                //* Mover para baixo
                                                IconButton(
                                                  onPressed: index < 1
                                                      ? null
                                                      : () {
                                                          String temp;
                                                          setState(() {
                                                            temp = procs![
                                                                index - 1];
                                                            procs![index - 1] =
                                                                procs![index];
                                                            procs![index] =
                                                                temp;

                                                            procsControllers[
                                                                        index - 1]
                                                                    .text =
                                                                procsControllers[
                                                                        index]
                                                                    .text;
                                                            procsControllers[
                                                                    index]
                                                                .text = temp;
                                                          });
                                                        },
                                                  icon: const Icon(
                                                      Icons.arrow_upward),
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
                                                      builder: (BuildContext
                                                          context) {
                                                        return Theme(
                                                          data: ThemeData(
                                                            brightness:
                                                                Brightness
                                                                    .light,
                                                            textTheme:
                                                                const TextTheme(
                                                              titleMedium:
                                                                  TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                          ),
                                                          child:
                                                              CupertinoAlertDialog(
                                                            title: const Text(
                                                                'Eliminar?'),
                                                            content: const Text(
                                                                'Deseja eliminar este procedimento permanentemente?'),
                                                            actions: [
                                                              CupertinoDialogAction(
                                                                isDefaultAction:
                                                                    true,
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    'Cancelar'),
                                                              ),
                                                              CupertinoDialogAction(
                                                                isDestructiveAction:
                                                                    true,
                                                                onPressed: () {
                                                                  setState(() {
                                                                    procs!.remove(
                                                                        procs![
                                                                            index]);
                                                                    procsControllers
                                                                        .remove(
                                                                            procsControllers[index]);
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    'Eliminar'),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  onPressed: index ==
                                                          procs!.length - 1
                                                      ? null
                                                      : () {
                                                          String temp;
                                                          setState(() {
                                                            temp = procs![
                                                                index + 1];
                                                            procs![index + 1] =
                                                                procs![index];
                                                            procs![index] =
                                                                temp;
                                                            procsControllers[
                                                                        index + 1]
                                                                    .text =
                                                                procsControllers[
                                                                        index]
                                                                    .text;
                                                            procsControllers[
                                                                    index]
                                                                .text = temp;
                                                          });
                                                        },
                                                  icon: const Icon(
                                                      Icons.arrow_downward),
                                                  tooltip: 'Mover para cima',
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            index < procs!.length - 1
                                                ? const Divider(
                                                    thickness: 1,
                                                    indent: 30,
                                                    endIndent: 30,
                                                    color: Colors.black,
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
                          padding: const EdgeInsets.only(
                              right: 16, left: 16, top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      if (procR.isNotEmpty) {
                                        procsControllers.add(
                                          TextEditingController(
                                            text: procR,
                                          ),
                                        );
                                        procs!.add(procR);
                                        _procController.text = '';
                                        procR = '';
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Divider(
                          indent: 40,
                          endIndent: 40,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 10),
                        //* Outras edições
                        const Text(
                          'Outras Opções',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: const Text(
                                'Tempo:',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: const SizedBox(
                                  width: 75,
                                  height: 1,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                          final newValue =
                                              double.tryParse(value);
                                          if (newValue != null &&
                                              newValue != tempo) {
                                            setState(() {
                                              tempo = newValue;
                                            });
                                          } else {
                                            tempo = 0;
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        controller: _tempoController,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'min',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: const Text(
                                'Porções:',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: const SizedBox(
                                  width: 75,
                                  height: 1,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Semantics(
                                    label: 'porcoes',
                                    child: SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: TextField(
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          final newValue =
                                              double.tryParse(value);
                                          if (newValue != null &&
                                              newValue != porcs) {
                                            setState(() {
                                              porcs = newValue;
                                            });
                                          } else {
                                            porcs = 0;
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        controller: _porcsController,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.person),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: const Text(
                                'Categoria:',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: const SizedBox(
                                  width: 75,
                                  height: 1,
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              value: categ,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
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
                                  categ = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: const Text(
                                'Favorita:',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: const SizedBox(
                                  width: 75,
                                  height: 1,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: Checkbox(
                                value: fav,
                                onChanged: (value) {
                                  setState(() {
                                    fav = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      //! Sair Button
                      Expanded(
                        child: GestureDetector(
                          onTapDown: (details) {
                            setState(() {
                              cancelColor = Colors.black12;
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              cancelColor = Colors.white;
                            });
                          },
                          onTapUp: (details) {
                            setState(() {
                              cancelColor = Colors.white;
                            });
                          },
                          onTap: () => Navigator.maybePop(context),
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                              color: cancelColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.red,
                              ),
                            ),
                            height: 50,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 250),
                            child: const Text(
                              'Sair',
                              style: TextStyle(fontSize: 22, color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTapDown: (details) {
                            setState(() {
                              saveColor = Colors.black12;
                            });
                          },
                          onTapCancel: () {
                            setState(() {
                              saveColor = Colors.white;
                            });
                          },
                          onTapUp: (details) {
                            setState(() {
                              saveColor = Colors.white;
                            });
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
                                  procedimento: procs,
                                  tempo: tempo!,
                                  porcoes: porcs!,
                                  categoria: categ!,
                                  favorita: fav,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                              color: saveColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.green,
                              ),
                            ),
                            height: 50,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 250),
                            child: const Text(
                              'Guardar & Sair',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.green),
                            ),
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
  }
}
