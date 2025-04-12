import 'package:flutter/material.dart';
import '../Shopping%20Lists/shopping_lists.dart';
import '../Recipe Pages/list_recipes.dart';
//*import '../list_favourites.dart';
import '../Settings/user_settings.dart';
import '../Recipe Pages/new_recipe.dart';

// Bottom App Bar Widget
Widget bottomAppBar(BuildContext context) => BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //Shopping List Button
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Lista de Compras',
            iconSize: 30,
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
            iconSize: 30,
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
            iconSize: 30,
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
            iconSize: 30,
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
      heroTag: 'newRecipe',
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
      //backgroundColor: Colors.lime[200],
      child: const Icon(
        Icons.add,
        size: 40,
        color: Colors.black,
      ),
    );
