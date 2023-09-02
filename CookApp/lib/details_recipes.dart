import 'package:flutter/material.dart';
import 'package:test_app/details_recipes_page.dart';

void showBigDialog(
  BuildContext context,
  String? foto,
  String name,
  String desc,
  List<String>? ings,
  List<String> ingsOpts,
  List<double> ingsQuant,
  List<String>? prep,
  double? prepTime,
  double? porcoes,
  String category,
) {
  //put form on top
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetailsForm(
        foto: foto,
        name: name,
        desc: desc,
        ings: ings,
        ingsOpts: ingsOpts,
        ingsQuant: ingsQuant,
        prep: prep,
        prepTime: prepTime,
        porcoes: porcoes,
        category: category,
      ),
      fullscreenDialog: true,
    ),
  );
}
