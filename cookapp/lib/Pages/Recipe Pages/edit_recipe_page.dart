//import 'dart:io';
//import 'dart:developer' as developer;

import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import '../../Functions/server_requests.dart';
import '../../Classes/recipes.dart';
import '../../Classes/ingredients.dart';
import '../../Functions/show_conf_dialog.dart';

class EditForm extends StatefulWidget {
  final Recipe toEditR;

  const EditForm({required this.toEditR, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  Recipe? toEditR; //receita a editar substitui o toEditR que é inacessível
  Image? foto;
  late String id = widget.toEditR.id;
  late String nome = widget.toEditR.title;
  late String desc = widget.toEditR.description;

  //* ings indicates the names od the ingredients
  late List<String>? ings = [];
  //* ingsT indicates the type of ingredient, more specifically, the unit of measurement
  late List<String>? ingsT = [];
  //* ingsQ indicates the quantity of the ingredient
  late List<double>? ingsQ = [];
  //* Convertion of the ingredients to all the seperate parts
  List<Ingredient> ingredients = [];
  List<IngBridge> bridges = [];

  //* procs indicates the steps of the recipe (Procs = Procedures)
  late List<String>? procs = [];
  late double? time = 0;
  late double? porcs = 0;
  late String? categ = 'Geral';
  late bool isPublic = false;
  ////late bool fav = false;

  late final TextEditingController _timeController;
  late final TextEditingController _porcsController;

  @override
  void initState() {
    super.initState();
    toEditR = widget.toEditR;
    // Get the image
    getRecipeImage(id, context).then(
      (value) => setState(() {
        foto = value;
      }),
    );
    id = widget.toEditR.id;
    nome = widget.toEditR.title;
    desc = widget.toEditR.description;
    ////ings = widget.toEditR.ingredients?.map((ing) => ing.name).toList() ?? [];
    ////ingsT = widget.toEditR.ingredients?.map((ing) => ing.unit).toList() ?? [];
    recipeIngredients(widget.toEditR.id, context).then((value) {
      setState(() {
        ingredients = value;
        ings = ingredients.map((ing) => ing.name).toList();
        ingsT = ingredients.map((ing) => ing.unit).toList();
      });
    });
    ingsQ = widget.toEditR.bridges?.map((ing) => ing.amount).toList() ?? [];
    procs = widget.toEditR.steps;
    time = widget.toEditR.time;
    porcs = widget.toEditR.servings;
    categ = widget.toEditR.getType();
    isPublic = widget.toEditR.isPublic;
    ////fav = false;
    //String? _selectedValue = categ;

    _timeController = TextEditingController(text: time!.toStringAsFixed(0));
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
    toEditR!.bridges!.length,
    (i) => TextEditingController(
      text: toEditR!.bridges![i].amount.toStringAsFixed(0),
    ),
  );

  late List<TextEditingController> procsControllers = List.generate(
    toEditR!.steps!.length,
    (i) => TextEditingController(text: toEditR!.steps![i]),
  );

  void failed(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void succeded(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return showConfDialog(context);
      },
      child: StatefulBuilder(
        builder: (context, setState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Editar Receita'),
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
                    toEditR!.title,
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
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: Column(
                            children: [
                              foto == null
                                  ? const IconButton(
                                      icon: Icon(Icons.image_not_supported),
                                      iconSize: 100,
                                      splashRadius: 65,
                                      color: Colors.grey,
                                      onPressed: null,
                                      //?() async {
                                      //?  var image = await ImagePicker()
                                      //?      .pickImage(
                                      //?          source: ImageSource.gallery);
                                      //?  setState(() {
                                      //?    foto = image == null
                                      //?        ? null
                                      //?        : Image.file(File(image.path));
                                      //?  });
                                      //?},
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(30),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: foto ??
                                                const Icon(
                                                  Icons.image_not_supported,
                                                  size: 100,
                                                  color: Colors.grey,
                                                ),
                                          ),
                                          const Positioned(
                                            right: 10,
                                            top: 10,
                                            child: IconButton(
                                              icon: Icon(Icons.edit_outlined),
                                              onPressed: null,
                                              //() async {
                                              //! Foto is a "IMAGE" type
                                              //},
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
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                    ),
                                    labelText: 'Nome',
                                  ),
                                  initialValue: nome,
                                  onChanged: (String? value) {
                                    setState(() {
                                      if (value != null) {
                                        nome = value;
                                      }
                                    });
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
                                  top: 16,
                                  right: 16,
                                  left: 16,
                                ),
                                child: TextFormField(
                                  key: _descKey,
                                  maxLength: 500,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                    ),
                                    labelText: 'Descrição',
                                  ),
                                  initialValue: desc,
                                  onChanged: (String? value) {
                                    setState(() {
                                      if (value != null) {
                                        desc = value;
                                      }
                                    });
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
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: ings!.length,
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Material(
                                          elevation: 5,
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            onLongPress: () {
                                              setState(() {
                                                ingredients.removeAt(index);
                                                ings!.remove(ings![index]);
                                                ////ingsT!.remove(ingsT![index]);
                                                ingsQ!.remove(ingsQ![index]);
                                                hintControllers.removeAt(
                                                  index,
                                                );
                                              });
                                            },
                                            leading: const SizedBox(),
                                            title: Text(
                                              ings![index],
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
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
                                                      controller: hintControllers[index],
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                      onChanged: (value) {
                                                        final newValue = double.tryParse(
                                                          value,
                                                        );
                                                        if (newValue != null) {
                                                          setState(() {
                                                            ingsQ![index] = newValue;
                                                          });
                                                        } else {
                                                          ingsQ![index] = 0;
                                                        }
                                                      },
                                                      keyboardType: TextInputType.number,
                                                      decoration: const InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText: '0',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                DropdownButton<String>(
                                                  value: ingsT![index],
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
                                                  ].map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                  onChanged: (
                                                    String? newValue,
                                                  ) {
                                                    setState(() {
                                                      ingsT![index] = newValue!;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(width: 10),
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
                            right: 16,
                            left: 16,
                            top: 16,
                          ),
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
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    ingsR = value;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 0,
                                child: Material(
                                  elevation: 5,
                                  shape: const CircleBorder(),
                                  child: IconButton(
                                    tooltip: 'Adicionar',
                                    splashRadius: 35,
                                    iconSize: 40,
                                    splashColor: Colors.black12,
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
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(
                          indent: 40,
                          endIndent: 40,
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
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: procs!.length,
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16,
                                          left: 8,
                                          right: 8,
                                          top: 24,
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
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              controller: procsControllers[index],
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                              decoration: const InputDecoration(
                                                label: Text(
                                                  'Procedimento',
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                      16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              textAlign: TextAlign.justify,
                                              onChanged: (value) {
                                                setState(() {
                                                  procs![index] = value;
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                            temp = procs![index - 1];
                                                            procs![index - 1] = procs![index];
                                                            procs![index] = temp;

                                                            procsControllers[index - 1].text = procsControllers[index].text;
                                                            procsControllers[index].text = temp;
                                                          });
                                                        },
                                                  icon: const Icon(
                                                    Icons.arrow_upward,
                                                  ),
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
                                                      builder: (
                                                        BuildContext context,
                                                      ) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            'Eliminar?',
                                                          ),
                                                          content: const Text(
                                                            'Deseja eliminar este procedimento permanentemente?',
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              child: const Text(
                                                                'Cancelar',
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  procs!.remove(
                                                                    procs![index],
                                                                  );
                                                                  procsControllers.remove(
                                                                    procsControllers[index],
                                                                  );
                                                                });
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              child: const Text(
                                                                'Eliminar',
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  onPressed: index == procs!.length - 1
                                                      ? null
                                                      : () {
                                                          String temp;
                                                          setState(() {
                                                            temp = procs![index + 1];
                                                            procs![index + 1] = procs![index];
                                                            procs![index] = temp;
                                                            procsControllers[index + 1].text = procsControllers[index].text;
                                                            procsControllers[index].text = temp;
                                                          });
                                                        },
                                                  icon: const Icon(
                                                    Icons.arrow_downward,
                                                  ),
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
                            right: 16,
                            left: 16,
                            top: 4,
                          ),
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
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16),
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      procR = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
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
                                        if (procR.isNotEmpty) {
                                          procsControllers.add(
                                            TextEditingController(text: procR),
                                          );
                                          procs!.add(procR);
                                          _procController.text = '';
                                          procR = '';
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Divider(
                          indent: 40,
                          endIndent: 40,
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
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: const Text(
                                'Tempo',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Spacer(flex: 1),
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Semantics(
                                    label: 'time',
                                    child: SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: TextField(
                                        style: const TextStyle(),
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          final newValue = double.tryParse(
                                            value,
                                          );
                                          if (newValue != null && newValue != time) {
                                            setState(() {
                                              time = newValue;
                                            });
                                          } else {
                                            time = 0;
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        controller: _timeController,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'min',
                                    style: TextStyle(
                                      fontSize: 18,
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
                                'Porções',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Spacer(flex: 1),
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
                                        style: const TextStyle(),
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          final newValue = double.tryParse(
                                            value,
                                          );
                                          if (newValue != null && newValue != porcs) {
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
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: const Text(
                                'Categoria',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Spacer(flex: 1),
                            DropdownButton<String>(
                              value: categ,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              items: <String>[
                                'Geral',
                                'Bolos',
                                'Tartes',
                                'Sobremesas',
                                'Pratos',
                              ].map<DropdownMenuItem<String>>((
                                String value,
                              ) {
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
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: const Text(
                                'Pública',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Spacer(flex: 1),
                            Container(
                              alignment: Alignment.center,
                              width: 125,
                              child: Switch(
                                value: isPublic,
                                onChanged: (value) {
                                  setState(() {
                                    isPublic = value;
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
                  //! Save Button
                  Material(
                    elevation: 10,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: (() {
                        if (_nameKey.currentState != null) {
                          // Verifies if there is a name
                          _nameKey.currentState!.validate();
                        }
                        if (_descKey.currentState != null) {
                          // Verifies if there is a description
                          _descKey.currentState!.validate();
                        }

                        if (nome.isNotEmpty && desc.isNotEmpty) {
                          // TODO: Finish this
                          //? Sending the update request to the server
                          List<IngBridge> ingsB = [];
                          List<String> ingIds = [];
                          List<double> ingramounts = [];
                          List<Map<String, String>> customM = [];
                          for (int i = 0; i < ings!.length; i++) {
                            try {
                              // Length -1 because i starts at 0 and the length starts at 1
                              // When i is at 2 it's already asking for the 3rd element
                              if (ingredients.length - 1 < i) {
                                // create a new ingredient if it doesn't exist
                                //developer.log("Creating new ingredient");
                                ingredients.add(
                                  Ingredient(
                                    id: "",
                                    name: ings![i],
                                    unit: ingsT![i],
                                    isVerified: false,
                                    tag: "",
                                  ),
                                );
                              }
                              // TODO: PROBLEM (ISSUE: #24)
                              //developer.log("Ingredient : ${ingredients[i].id}");
                              //developer.log("Amount     : ${ingsQ?[i]}");
                              //developer.log("Custom Unit: ${ingsT?[i]}");
                              ingsB.add(
                                IngBridge(
                                  id: "",
                                  ingredient: ingredients[i].id,
                                  amount: ingsQ?[i] ?? 0,
                                  customUnit: ingsT?[i],
                                ),
                              );
                            } catch (e) {
                              ingsB.add(
                                IngBridge(
                                  id: "",
                                  ingredient: ingredients[i].id,
                                  amount: 0,
                                  customUnit: ingsT?[i],
                                ),
                              );
                            }
                            if (ingredients[i].id == "") {
                              continue;
                            }
                            ingIds.add(ingredients[i].id);
                            ingramounts.add(ingsB[i].amount);
                            customM.add({
                              'IngGUID': ingredients[i].id,
                              'Amount': ingsB[i].amount.toString(),
                              'CustomUnit': ingsT![i],
                            });
                          }

                          final List<Ingredient> noIdIngs = ingredients
                              .where(
                                (element) => element.id.isEmpty || element.id == "",
                              )
                              .toList();

                          // Send the ingredients to the server
                          newIngredients(noIdIngs, context).then((value) {
                            for (String id in value) {
                              if (ingIds.contains(id)) {
                                // If it already has the id, skip it
                                continue;
                              }
                              ingIds.add(id);
                              customM.add({
                                'IngGUID': id,
                                'Amount': ingsQ![ingIds.indexOf(id)].toString(),
                                'CustomUnit': ingsT![ingIds.indexOf(id)],
                              });
                              ingramounts.add(ingsQ![ingIds.indexOf(id)]);
                              ingsB.add(
                                IngBridge(
                                  id: "",
                                  ingredient: id,
                                  amount: ingsQ![ingIds.indexOf(id)],
                                  customUnit: ingsT![ingIds.indexOf(id)],
                                ),
                              );
                            }

                            RecipeC(
                              title: nome,
                              description: desc,
                              ////ingredients: ings!,
                              customIngM: customM,
                              ingramounts: ingramounts,
                              steps: procs!,
                              time: time!,
                              portions: porcs!,
                              type: 0, //categ!,
                              isPublic: isPublic,
                              ingredientIds: ingIds,
                              //isFavourite: fav,
                              // ignore: use_build_context_synchronously
                            ).update(id, context).then((value) {
                              if (value) {
                                succeded("Receita atualizada com sucesso!");
                              } else {
                                failed("Erro ao atualizar receita!");
                              }
                            });
                          });

                          //Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor preencha todos os campos obrigatórios.',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }),
                      icon: const Icon(Icons.cloud_upload_outlined),
                      iconSize: 60,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
