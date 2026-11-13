import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/model/recipe_model.dart';

class LocalCacheService {
  static const String _boxName = 'recipes_cache_box';
  static const String _recipesKey = 'cached_recipes';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_boxName);
  }

  Box<String> get _box => Hive.box<String>(_boxName);

  Future<void> saveRecipes(List<Recipe> recipes) async {
    final jsonList = recipes.map((r) => r.toJson()).toList();
    await _box.put(_recipesKey, jsonEncode(jsonList));
  }

  List<Recipe> getCachedRecipes() {
    final rawData = _box.get(_recipesKey);
    if (rawData == null) return [];
    final List decoded = jsonDecode(rawData);
    return decoded.map((json) => Recipe.fromJson(json)).toList();
  }
}
