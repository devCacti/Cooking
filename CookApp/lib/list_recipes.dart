import 'package:flutter/material.dart';
import 'receita.dart';

class ListRecipesForm extends StatefulWidget {
  const ListRecipesForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListRecipesFormState createState() => _ListRecipesFormState();
}

class _ListRecipesFormState extends State<ListRecipesForm> {
  List<Recipe>? recipes;

  @override
  void initState() {
    super.initState();
    //recipes = loadRecipes() as List<Recipe>?;
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
              // ignore: unnecessary_null_comparison
              recipes != null
                  ? Expanded(
                      child: Scrollbar(
                        child: ListView(
                          restorationId: 'test_load_recipes',
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          children: [
                            for (var recipe in recipes as List<Recipe>)
                              ListTile(
                                leading: ExcludeSemantics(
                                  child:
                                      CircleAvatar(child: Text('${recipe.id}')),
                                ),
                                title: Text(recipe.nome),
                                subtitle: Text(recipe.descricao),
                              ),
                          ],
                        ),
                      ),
                    )
                  : const Text('miau'),
            ],
          ),
        ),
      ),
    );
  }
}
