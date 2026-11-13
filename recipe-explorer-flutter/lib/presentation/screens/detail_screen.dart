import 'package:flutter/material.dart';
import '../../data/model/recipe_model.dart';

class DetailScreen extends StatelessWidget {
  final Recipe recipe;

  const DetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                recipe.image,
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 100),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              recipe.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Cuisine: ${recipe.cuisine} | Difficulty: ${recipe.difficulty}',
              style: const TextStyle(fontSize: 16, color: Colors.deepOrange),
            ),
            const SizedBox(height: 8),
            Text('Prep: ${recipe.prepTimeMinutes} mins | Cook: ${recipe.cookTimeMinutes} mins | Servings: ${recipe.servings}'),
            Text('Rating: ${recipe.rating} / 5.0'),
            const Divider(height: 24),
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            ...recipe.ingredients.map((i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text('• $i'),
                )),
            const Divider(height: 24),
            const Text(
              'Instructions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            ...recipe.instructions.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('${entry.key + 1}. ${entry.value}'),
                )),
          ],
        ),
      ),
    );
  }
}
