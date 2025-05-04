//? Recipe detail page

import 'package:flutter/material.dart';
import '../../Functions/server_requests.dart';
import '../../Classes/recipes.dart';
import '../../Classes/ingredients.dart';

class RecipeDetail extends StatefulWidget {
  final Recipe recipe;
  final Image? image;

  const RecipeDetail({super.key, required this.recipe, this.image});

  @override
  // ignore: library_private_types_in_public_api
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  Recipe recipe = Recipe.defaultR();
  List<Ingredient> ingredients = [];
  bool loading = true;
  bool imageIsPlaceholder = false;
  final int imageHeight = 100;

  @override
  void initState() {
    super.initState();

    recipe = widget.recipe;

    recipeIngredients(recipe.id).then((value) => setState(() {
          ////developer.log(value);
          ////developer.log(recipe.bridges.toString());
          ingredients = value;
          loading = false;
        }));

    // Check if the image is a placeholder
    if (widget.image == null || widget.image!.image == const AssetImage("assets/images/LittleMan.png")) {
      imageIsPlaceholder = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Detalhes de Receita",
        ),
      ),
      body: ListView(
        children: [
          //* Recipe Image
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              // Just use the height of the image if it doesn't exceed the width of the screen
              width: MediaQuery.of(context).size.width / 2,
              child: !imageIsPlaceholder
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image(
                        image: widget.image!.image,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ),
            ),
          ),
          //* Recipe Title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              recipe.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //* Recipe Description
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              recipe.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const Divider(
            indent: 80,
            endIndent: 80,
          ),
          //* Recipe Ingredients
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Ingredientes",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    ////developer.log(recipe.bridges?[index].ingredient ?? "null");
                    return Column(
                      children: [
                        Text(
                          // If the ingredients list is not empty
                          ingredients.isNotEmpty
                              // Use the name from the ingredient
                              ? ingredients[index].name
                              // Otherwise use the ingredient GUID
                              : recipe.bridges![index].ingredient,
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              recipe.bridges?[index].amount.toString().replaceAll(r'.', ',') ?? "",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              // If the ingredients list is not empty
                              recipe.bridges![index].customUnit == null
                                  // Use the amount and unit from the ingredient
                                  ? " ${ingredients[index].unit}"
                                  // Otherwise use the amount and custom unit from the recipe
                                  : " ${recipe.bridges![index].customUnit}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    );
                  },
                ),
          const Divider(
            indent: 80,
            endIndent: 80,
          ),
          //* Recipe Procedure
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Procedimento",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recipe.steps!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Text(
                    "Passo N.º ${index + 1}",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.steps![index],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              );
            },
          ),
          //* Recipe Details (Preparation Time, Servings, etc.)
          const Divider(
            indent: 80,
            endIndent: 80,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Detalhes",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              const Text("Tempo de Preparação", style: TextStyle(fontSize: 16)),
              Text(
                "${recipe.time} minutos",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              const Text("Porções", style: TextStyle(fontSize: 16)),
              Text(
                // Remove the ".0" from the end of the number
                recipe.servings.toString().substring(0, recipe.servings.toString().length - 2),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              ////const SizedBox(height: 8),
              ////Text(
              ////  "Dificuldade: ${recipe.difficulty}",
              ////  style: const TextStyle(
              ////    fontSize: 20,
              ////  ),
              ////),
              const SizedBox(height: 8),
              const Text(
                "Categoria",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                recipe.getType(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ],
      ),
    );
  }
}
