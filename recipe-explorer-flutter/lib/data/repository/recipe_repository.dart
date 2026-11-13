import '../../services/local_cache_service.dart';
import '../datasource/api_service.dart';
import '../model/recipe_model.dart';

class RecipeRepository {
  final ApiService _apiService;
  final LocalCacheService _cacheService;

  RecipeRepository({
    ApiService? apiService,
    LocalCacheService? cacheService,
  })  : _apiService = apiService ?? ApiService(),
        _cacheService = cacheService ?? LocalCacheService();

  Future<List<Recipe>> getRecipes({
    int limit = 10,
    int skip = 0,
    bool forceRefresh = false,
  }) async {
    try {
      final remoteRecipes = await _apiService.fetchRecipes(
        limit: limit,
        skip: skip,
      );

      if (skip == 0 || forceRefresh) {
        await _cacheService.saveRecipes(remoteRecipes);
      } else {
        final existing = _cacheService.getCachedRecipes();
        await _cacheService.saveRecipes([...existing, ...remoteRecipes]);
      }

      return remoteRecipes;
    } catch (e) {
      if (skip == 0) {
        final cached = _cacheService.getCachedRecipes();
        if (cached.isNotEmpty) {
          return cached;
        }
      }
      rethrow;
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      return await _apiService.searchRecipes(query);
    } catch (_) {
      final cached = _cacheService.getCachedRecipes();
      return cached
          .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<Recipe> addRecipe(Recipe recipe) async {
    try {
      return await _apiService.createRecipe(recipe);
    } catch (_) {
      return recipe;
    }
  }

  Future<Recipe> updateRecipe(Recipe recipe) async {
    try {
      if (recipe.id <= 50) {
        return await _apiService.updateRecipe(recipe);
      }
      return recipe;
    } catch (_) {
      return recipe;
    }
  }

  Future<void> deleteRecipe(int id) async {
    try {
      if (id <= 50) {
        await _apiService.deleteRecipe(id);
      }
    } catch (_) {}
  }

  Future<void> syncCache(List<Recipe> currentList) async {
    await _cacheService.saveRecipes(currentList);
  }
}
