// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'receita.dart'; // Import the Recipe class from recipe.dart

// Your Flutter app code here...

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? nome = '';
  String? desc = '';
  String? ingr = '';
  String? step = '';

  List<Recipe>? recipes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (newValue) {
                  nome = newValue;
                }),
            TextFormField(
                decoration: const InputDecoration(
                  labelText: 'description',
                ),
                onChanged: (newValue) {
                  desc = newValue;
                }),
            TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ingredients',
                ),
                onChanged: (newValue) {
                  ingr = newValue;
                }),
            TextFormField(
                decoration: const InputDecoration(
                  labelText: 'steps',
                ),
                onChanged: (newValue) {
                  step = newValue;
                }),
            ElevatedButton(
              onPressed: () async {
                Recipe newRecipe = Recipe(
                  id: await getNextId(),
                  nome: nome!,
                  descricao: desc!,
                  ingredientes: ingr!,
                  procedimento: step!,
                  tempo: 1,
                );
                saveRecipe(newRecipe);
                // ignore: avoid_print
                print("Saved!");
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () async {
                recipes = await loadRecipes();
                for (var recipe in recipes!) {
                  // ignore: avoid_print
                  print(recipe.nome);
                }
                setState(() {});
              },
              child: const Text('Load'),
            ),
            recipes == null
                ? Expanded(
                    child: Scrollbar(
                      child: ListView(
                        restorationId: 'test_load_recipes',
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          for (var recipe in recipes ?? [])
                            ListTile(
                              leading: ExcludeSemantics(
                                child:
                                    CircleAvatar(child: Text('${recipe.id}')),
                              ),
                              title: Text(recipe.name),
                              subtitle: Text(recipe.description),
                            ),
                        ],
                      ),
                    ),
                  )
                : const Text('miau'),
          ],
        ),
      ),
    );
  }
}
