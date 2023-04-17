import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class NewRecipeForm extends StatefulWidget {
  const NewRecipeForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewRecipeFormState createState() => _NewRecipeFormState();
}

//FUNCAO PARA APARECER O ALERT

class _NewRecipeFormState extends State<NewRecipeForm> {
  XFile? _image;
  String? _selectedValue;
  double tempoCozi = 0;
  bool? favorita = false;
  bool? validate = false;

  //Nome
  final _nameKey = GlobalKey<FormFieldState>();
  final TextEditingController _nameController = TextEditingController();

  final _ingredientsKey = GlobalKey<FormFieldState>();
  final _procedureKey = GlobalKey<FormFieldState>();
  final _categoryKey = GlobalKey<FormFieldState>();

  String? dropdownValidator(String? value) {
    if (value == null) {
      return 'Please select an option';
    }
    return null;
  }

  final TextEditingController _textEditingController = TextEditingController();

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
                  Navigator.pushReplacementNamed(
                      context, 'Miau'); // navigate to home page
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

  Future<void> _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nova Receita'),
          centerTitle: true,
          shadowColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.only(
                  left: 72.0,
                  right: 72.0,
                  top: 32,
                  bottom: 32,
                ),
                child: _image == null
                    ? IconButton(
                        icon: const Icon(Icons.camera_alt_outlined),
                        iconSize: 75,
                        onPressed: _getImage,
                        tooltip: 'Escolher Foto',
                      )
                    : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(_image!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: _getImage,
                              tooltip: 'Mudar Foto',
                              iconSize: 40,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      )),
            Padding(
              padding: const EdgeInsets.only(right: 32, left: 32),
              child: TextFormField(
                  key: _nameKey,
                  controller: _nameController,
                  maxLength: 75,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    hintText: 'Escreva um nome',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor insira um nome';
                    }
                    return null;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 32, left: 32, top: 8),
              child: TextFormField(
                maxLines: null,
                maxLength: 500,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Escreva uma descrição',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Divider(
              indent: 100,
              endIndent: 100,
              height: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 32, left: 32, top: 16),
              child: TextFormField(
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Ingredientes',
                  hintText: 'Insira os ingredientes necessários',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 32, left: 32, top: 16),
              child: TextFormField(
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Confecionamento',
                  hintText: 'Descreva o procedimento',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(32),
              child: Divider(
                indent: 100,
                endIndent: 100,
                height: 1,
                color: Colors.grey,
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 16,
                ),
                child: Text(
                  'Outros detalhes',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
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
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 32, bottom: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Tempo (Mins):',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                              CupertinoSlider(
                                min: 0,
                                max: 240,
                                value: tempoCozi,
                                onChanged: (value) {
                                  setState(() {
                                    tempoCozi = value;
                                    _textEditingController.text =
                                        tempoCozi.toStringAsFixed(0);
                                  });
                                },
                              ),
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
                                              newValue != tempoCozi) {
                                            setState(() {
                                              tempoCozi = newValue.clamp(0, 240)
                                                  as double;
                                            });
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        controller: _textEditingController,
                                      ))),
                            ])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Categoria:',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                          height: 1,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                          ),
                          child: const SizedBox(
                            width: 75,
                            height: 1,
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                          height: 1,
                        ),
                        DropdownButton<String>(
                          value: _selectedValue,
                          hint: const Text(
                            'Escolha...',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                          ),
                          items: <String>['Bolos', 'Sobremesas', 'Pratos']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedValue = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Favorita',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                            height: 1,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: const SizedBox(
                              width: 75,
                              height: 1,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                            height: 1,
                          ),
                          Checkbox(
                            value: favorita,
                            onChanged: (value) {
                              setState(() {
                                favorita = value;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 32,
                bottom: 64,
              ),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.save),
                  highlightColor: Colors.orange,
                  tooltip: 'Guardar',
                  onPressed: () {
                    if (_nameKey.currentState!.validate() &&
                        _selectedValue != null) {
                    } else {
                      validate = true;
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Por favor preencha todos os campos necessários',
                          ),
                          action: SnackBarAction(label: 'OK', onPressed: () {}),
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          ]),
        )),
      ),
      onWillPop: () => showConfirmationDialog(context),
    );
  }
}
