//? Recipe detail page

import 'package:flutter/material.dart';
import '../../Functions/data_structures.dart';

class RecipeDetail extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetail({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),
      body: ListView(
        children: [
          //* Recipe Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                //TODO: This method is a very interesting method of getting images;
                image: NetworkImage(
                  "https://cookclever.pt/Recipes/Image?id=${widget.recipe.id}",
                ),
                onError: (exception, stackTrace) => const AssetImage(
                  "assets/images/placeholder.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //* Recipe Description
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.recipe.description,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          //* Recipe Ingredients
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Ingredientes",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.recipe.bridges!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.recipe.bridges![index].ingredient),
                subtitle: Text(
                  "${widget.recipe.bridges![index].amount} ${widget.recipe.bridges![index].customUnit}",
                ),
              );
            },
          ),
          //* Recipe Procedure
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Procedimento",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.recipe.steps.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${index + 1}. ${widget.recipe.steps[index]}"),
              );
            },
          ),
        ],
      ),
    );
  }
}
