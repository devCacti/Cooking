import 'package:cookapp/Classes/app_state.dart';
import 'package:cookapp/Classes/snackbars.dart';
import 'package:cookapp/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Shopping%20Lists/shopping_lists.dart';
import '../Recipe Pages/list_recipes.dart';
//*import '../list_favourites.dart';
import '../../Settings/user_settings.dart';
import '../Recipe Pages/new_recipe.dart';

enum PageType {
  shoppingList,
  recipes,
  home,
  profile,
}

// Bottom App Bar Widget
Widget bottomAppBar(BuildContext context, PageType currentPage) => BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //Shopping List Button
          IconButton(
            icon: currentPage == PageType.shoppingList ? const Icon(Icons.shopping_cart) : const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Lista de Compras',
            iconSize: 30,
            onPressed: currentPage == PageType.shoppingList
                ? null // Disable the button if already on the shopping list page
                : () {
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
            icon: currentPage == PageType.recipes ? const Icon(Icons.book) : const Icon(Icons.book_outlined),
            tooltip: 'Receitas',
            iconSize: 30,
            onPressed: currentPage == PageType.recipes
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListRecipesForm(),
                      ),
                    );
                  },
          ),
          //Main Page Button
          IconButton(
            icon: currentPage == PageType.home ? const Icon(Icons.home) : const Icon(Icons.home_outlined),
            tooltip: 'Main Page ',
            iconSize: 35,
            onPressed: currentPage == PageType.home
                ? null // Disable the button if already on the home page
                : () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(title: 'Cooking'),
                      ),
                    );
                  },
          ),
          //Profile       Button
          IconButton(
            icon: currentPage == PageType.profile ? const Icon(Icons.account_circle) : const Icon(Icons.account_circle_outlined),
            tooltip: 'Perfil',
            iconSize: 30,
            onPressed: currentPage == PageType.profile
                ? null
                : () {
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

Widget actionButton(BuildContext context) {
  final appState = context.watch<AppState>();
  return FloatingActionButton(
    heroTag: 'newRecipe',
    onPressed: !appState.isLoggedIn
        ? () {
            showSnackbar(
              context,
              'Por favor, faça login.',
              type: SnackBarType.info,
              isBold: true,
            );
          }
        : () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewRecipeForm(context: context),
              ),
            );
          },
    tooltip: 'Nova Receita',
    shape: const CircleBorder(),
    backgroundColor:
        appState.isLoggedIn ? Theme.of(context).appBarTheme.backgroundColor : Theme.of(context).disabledColor.withAlpha((0.1 * 255).toInt()),
    //backgroundColor: Colors.lime[200],
    child: Icon(
      Icons.add,
      size: 40,
      color: Colors.black,
    ),
  );
}
