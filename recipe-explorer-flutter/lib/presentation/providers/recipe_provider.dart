import 'package:flutter/material.dart';
import '../../core/api_constants.dart';
import '../../data/model/recipe_model.dart';
import '../../data/repository/recipe_repository.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeRepository _repository = RecipeRepository();

  List<Recipe> _recipes = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  Future<void> loadRecipes({bool refresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    if (refresh) _hasMore = true;
    notifyListeners();

    try {
      _recipes = await _repository.getRecipes(
        limit: ApiConstants.pageLimit,
        skip: 0,
        forceRefresh: refresh,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreRecipes() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextBatch = await _repository.getRecipes(
        limit: ApiConstants.pageLimit,
        skip: _recipes.length,
      );

      if (nextBatch.isEmpty) {
        _hasMore = false;
      } else {
        _recipes.addAll(nextBatch);
      }
    } catch (_) {
      _hasMore = false;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      await loadRecipes(refresh: true);
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recipes = await _repository.searchRecipes(query);
      _hasMore = false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRecipe(String name, String cuisine, String difficulty) async {
    final newRecipe = Recipe(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      ingredients: ['Ingredient 1', 'Ingredient 2'],
      instructions: ['Step 1: Prepare', 'Step 2: Cook'],
      prepTimeMinutes: 15,
      cookTimeMinutes: 30,
      servings: 4,
      difficulty: difficulty,
      cuisine: cuisine,
      rating: 5.0,
      image: 'https://dummyjson.com/image/150',
    );

    final created = await _repository.addRecipe(newRecipe);
    _recipes.insert(0, created.copyWith(id: newRecipe.id));
    await _repository.syncCache(_recipes);
    notifyListeners();
  }

  Future<void> editRecipe(Recipe updated) async {
    final result = await _repository.updateRecipe(updated);
    final index = _recipes.indexWhere((r) => r.id == updated.id);
    if (index != -1) {
      _recipes[index] = result;
      await _repository.syncCache(_recipes);
      notifyListeners();
    }
  }

  Future<void> removeRecipe(int id) async {
    await _repository.deleteRecipe(id);
    _recipes.removeWhere((r) => r.id == id);
    await _repository.syncCache(_recipes);
    notifyListeners();
  }
}
