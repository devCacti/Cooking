import 'package:flutter/material.dart';
import 'package:test_app/receita.dart';
import 'details_recipes.dart';
import 'new_recipe.dart';
import 'list_recipes.dart';
import 'list_favoritas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cook',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(
        title: 'Miau',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: FractionallySizedBox(
                    alignment: Alignment.center,
                    widthFactor: 0.5,
                    child: InkWell(
                      onTap: () {
                        Recipe receita = Recipe(
                          id: 0,
                          foto: null,
                          nome: "Massa cozida",
                          descricao:
                              "Preparação de massa para apenas uma pessoa.",
                          ingredientes: [
                            "Massa",
                            "Água",
                            "Óleo",
                            "Sal grosso",
                            "Panela",
                          ],
                          ingTipo: [
                            "g",
                            "L",
                            "mL",
                            "colh.",
                            "unid.",
                          ],
                          ingQuant: [
                            20,
                            1,
                            5,
                            0.5,
                            1,
                          ],
                          procedimento: [
                            "Meter o Litro de água dentro da panela.",
                            "Ligar o fogão no máximo.",
                            "Meter um fio de óleo e a metade de colher de sal, colher não maior que o pulgar.",
                            "Esperar que a água comece a borbulhar.",
                            "Colocar a massa. (Medir fazendo um circulo com o indicador e o pulgar).",
                          ],
                          tempo: 20,
                          porcoes: 1,
                          categoria: "Pratos",
                          favorita: false,
                        );
                        showBigDialog(
                          context,
                          receita.foto,
                          receita.nome,
                          receita.descricao,
                          receita.ingredientes,
                          receita.ingTipo!,
                          receita.ingQuant!,
                          receita.procedimento,
                          receita.tempo,
                          receita.porcoes,
                          receita.categoria,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black12,
                        ),
                        height: MediaQuery.of(context).size.width / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: const [
                                  Icon(
                                    Icons.fastfood,
                                    size: 100,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                  Text(
                                    'Massa',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Preparação de massa para apenas uma pessoa.',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  indent: 100,
                  endIndent: 100,
                  color: Colors.black,
                ),
                const Text(
                  'Sobre',
                  style: TextStyle(fontSize: 36, height: 2),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32),
                  child: Column(
                    children: const [
                      Text(
                        '\tBem-vindo à minha aplicação de receitas! Sou um estudante que adora programar e estou entusiasmado por partilhar o meu primeiro projeto consigo.'
                        '\n\n\tEnquanto pensava em ideias para a minha PAP, a minha mãe perguntou-me se conseguia criar uma aplicação onde pudesse guardar as suas próprias receitas.'
                        '\n\tE assim nasceu esta aplicação!'
                        '\n\n\tEsta aplicação tem como objetivo dar-lhe a oportunidade de adicionar facilmente as suas receitas à sua coleção e aceda a elas a qualquer momento, em qualquer lugar. E também para que mantenha todas as suas receitas favoritas organizadas num só lugar e nunca se esqueça de como fazer aquele prato especial novamente.'
                        '\n\n\tEspero que goste de usar esta aplicação para acompanhar todas as suas criações culinárias!',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 26,
                          height: 2.25,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      //end Column
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: 'Lista de Compras',
              iconSize: 35,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.local_dining),
              tooltip: 'Receitas',
              iconSize: 35,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ListRecipesForm()),
                );
              },
            ),
            const SizedBox(),
            IconButton(
              icon: const Icon(Icons.favorite),
              tooltip: 'Favoritas',
              iconSize: 35,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ListFavoutiresForm()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Conta',
              iconSize: 35,
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewRecipeForm()),
          );
        },
        tooltip: 'Nova Receita',
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
