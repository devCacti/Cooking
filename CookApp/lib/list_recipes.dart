import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'receita.dart';

class ListRecipesForm extends StatefulWidget {
  const ListRecipesForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListRecipesFormState createState() => _ListRecipesFormState();
}

class _ListRecipesFormState extends State<ListRecipesForm> {
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    loadRecipes().then((recipes) {
      setState(() {
        _recipes = recipes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 48, left: 8, right: 8),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
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
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                tooltip: 'Voltar',
                                icon: const Icon(Icons.arrow_back),
                              ),
                            ),
                          ),
                          const Text(
                            'Esta página serve para voçê ver as receitas que criou, clique numa para ver os seus detalhes.\n\nNesta aplicação pode estar à vontade porque não tem limite de receitas. ;)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              //! CASO ESTEJA ALGO A CORRER MAL PODEM SER ESTES ELEMENTOS O PROBLEMA!
              SizedBox(
                height: 500, //MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: _recipes.length,
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
                            _recipes[index].nome,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(_recipes[index].descricao),
                          leading: _recipes[index].foto != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(_recipes[index].foto!),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
