import 'package:flutter/material.dart';
import 'new_recipe.dart';

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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//Floating modal function
class AboutDialog extends StatelessWidget {
  const AboutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: [
          const Text(
            'Sobre',
            style: TextStyle(fontSize: 30, height: 2),
          ),
          Expanded(
              child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: const [
                      Text(
                        '\tBem-vindo à minha aplicação de receitas! Sou um estudante que adora programar e estou entusiasmado por partilhar o meu mais recente projeto consigo.'
                        '\n\n\tEnquanto pensava em ideias para a minha PAP, a minha mãe pediu-me para criar uma aplicação onde pudesse guardar as suas próprias receitas.'
                        '\n\tE assim nasceu esta aplicação!'
                        '\n\n\tEsta aplicação tem como objetivo dar-lhe a oportunidade de adicionar facilmente as suas receitas à sua coleção e aceda a elas a qualquer momento, em qualquer lugar. E também para que mantenha todas as suas receitas favoritas organizadas num só lugar e nunca se esqueça de como fazer aquele prato especial novamente.'
                        '\n\n\tEspero que goste de usar a nossa aplicação para acompanhar todas as suas criações culinárias!',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 20,
                          height: 2,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        width: 100,
                      ),
                    ],
                  ))
            ],
          )),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '  \tFechar\t  ',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ])
        ]));
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: 'Sobre',
              iconSize: 35,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AboutDialog();
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.local_dining),
              tooltip: 'Receitas',
              iconSize: 35,
              onPressed: () {},
            ),
            const SizedBox(),
            IconButton(
              icon: const Icon(Icons.favorite),
              tooltip: 'Favoritas',
              iconSize: 35,
              onPressed: () {},
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
