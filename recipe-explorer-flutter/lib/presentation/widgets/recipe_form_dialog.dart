import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/recipe_model.dart';
import '../providers/recipe_provider.dart';

class RecipeFormDialog extends StatefulWidget {
  final Recipe? recipe;

  const RecipeFormDialog({super.key, this.recipe});

  @override
  State<RecipeFormDialog> createState() => _RecipeFormDialogState();
}

class _RecipeFormDialogState extends State<RecipeFormDialog> {
  late TextEditingController _nameController;
  late TextEditingController _cuisineController;
  late TextEditingController _difficultyController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.recipe?.name ?? '');
    _cuisineController = TextEditingController(text: widget.recipe?.cuisine ?? '');
    _difficultyController = TextEditingController(text: widget.recipe?.difficulty ?? 'Easy');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cuisineController.dispose();
    _difficultyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.recipe != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Recipe' : 'Add Recipe'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Recipe Name'),
          ),
          TextField(
            controller: _cuisineController,
            decoration: const InputDecoration(labelText: 'Cuisine'),
          ),
          TextField(
            controller: _difficultyController,
            decoration: const InputDecoration(labelText: 'Difficulty (Easy/Medium)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            final cuisine = _cuisineController.text.trim();
            final difficulty = _difficultyController.text.trim();

            if (name.isEmpty) return;

            final provider = context.read<RecipeProvider>();
            if (isEditing) {
              provider.editRecipe(
                widget.recipe!.copyWith(
                  name: name,
                  cuisine: cuisine,
                  difficulty: difficulty,
                ),
              );
            } else {
              provider.addRecipe(name, cuisine, difficulty);
            }
            Navigator.pop(context);
          },
          child: Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}
