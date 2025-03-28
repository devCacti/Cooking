import 'dart:convert';
import 'dart:io';

class Ingredient {
  String id;
  String name;
  String unit;
  bool isVerified;
  String? tag;

  Ingredient({
    required this.id,
    required this.name,
    required this.unit,
    this.isVerified = false,
    this.tag,
  });

  // TODO: This function does not work
  void save() {
    // Create directory
    var dir = Directory('recipes/ingredients');
    if (!dir.existsSync()) {
      dir.createSync();
    }
    // Save the ingredient to the application files
    String name = 'recipes/ingredients/$id.json';

    var file = File(name);
    file.writeAsStringSync(jsonEncode(toJson()));
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['GUID'],
      name: json['Name'],
      unit: json['Unit'] ?? '',
      isVerified: json['isVerified'] ?? false,
      tag: json['Tag'] ?? '',
    );
  }

  // Convert into json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'isVerified': isVerified,
      'tag': tag,
    };
  }

  void saveWithIng(Ingredient ingredient) {
    // Create directory
    var dir = Directory('recipes/ingredients');
    if (!dir.existsSync()) {
      dir.createSync();
    }
    // Save the ingredient to the application files
    String name = 'recipes/ingredients/${ingredient.id}.json';

    // Update the current instance with the new ingredient
    id = ingredient.id;
    name = ingredient.name;
    unit = ingredient.unit;
    isVerified = ingredient.isVerified;
    tag = ingredient.tag;

    var file = File(name);
    file.writeAsStringSync(jsonEncode(ingredient));
  }
}

class IngBridge {
  String id;
  String ingredient; // Ingredient id
  double amount;
  String? customUnit;

  IngBridge({
    required this.id,
    required this.ingredient,
    required this.amount,
    this.customUnit,
  });

  factory IngBridge.fromJson(Map<String, dynamic> json) {
    return IngBridge(
      id: json['GUID'],
      ingredient: json['IngGUID'],
      amount: (json['Amount'] is int)
          ? (json['Amount'] as int).toDouble()
          : (json['Amount'] ?? 0.0) as double,
      customUnit: json['CustomUnit'],
    );
  }

  // Override equality operator to compare based on the `ingredient` field
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IngBridge && other.ingredient == ingredient;
  }

  @override
  int get hashCode => ingredient.hashCode;
}
