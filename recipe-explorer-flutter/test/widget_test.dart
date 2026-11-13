import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_explorer_flutter/data/model/recipe_model.dart';

void main() {
  test('Recipe model parses JSON properly', () {
    final json = {
      'id': 1,
      'name': 'Classic Margherita Pizza',
      'ingredients': ['Pizza dough', 'Tomato sauce'],
      'instructions': ['Roll dough', 'Bake'],
      'prepTimeMinutes': 20,
      'cookTimeMinutes': 15,
      'servings': 4,
      'difficulty': 'Easy',
      'cuisine': 'Italian',
      'rating': 4.6,
      'image': 'https://dummyjson.com/image/150',
    };
    final recipe = Recipe.fromJson(json);
    expect(recipe.id, 1);
    expect(recipe.name, 'Classic Margherita Pizza');
    expect(recipe.cuisine, 'Italian');
  });
}
