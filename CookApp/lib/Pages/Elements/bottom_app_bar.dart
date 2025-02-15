import 'package:flutter/material.dart';
import '../Shopping%20Lists/shopping_lists.dart';
import '../list_recipes.dart';
//*import '../list_favourites.dart';
import '../user_settings.dart';
import '../new_recipe.dart';

// Bottom App Bar Widget
Widget bottomAppBar(BuildContext context) => BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //Shopping List Button
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Lista de Compras',
            iconSize: 35,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShoppingLists(),
                ),
              );
            },
          ),
          //Recipes       Button
          IconButton(
            icon: const Icon(Icons.book_outlined),
            tooltip: 'Receitas',
            iconSize: 35,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListRecipesForm(),
                ),
              );
            },
          ),
          //Favourites    Button
          const
          // It's a constant for now
          IconButton(
            icon: //const
                Icon(Icons.favorite_outline),
            tooltip: 'Favoritas',
            iconSize: 35,
            onPressed: null,
            //*() {
            //* This code is going to be used but is commented out for now
            //*Navigator.push(
            //*  context,
            //*  MaterialPageRoute(
            //*    builder: (context) => const ListFavoutiresForm(),
            //*  ),
            //*);
            //*},
          ),
          //Profile       Button
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Perfil',
            iconSize: 35,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserSettings(),
                ),
              );
            },
          ),
        ],
      ),
    );

Widget actionButton(BuildContext context) => FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewRecipeForm(context: context),
          ),
        );
      },
      tooltip: 'Nova Receita',
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add,
        size: 40,
      ),
    );
