import 'package:dio/dio.dart';
import '../../core/api_constants.dart';
import '../model/recipe_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<Recipe>> fetchRecipes({int limit = 10, int skip = 0}) async {
    try {
      final response = await _dio.get(
        ApiConstants.recipesEndpoint,
        queryParameters: {'limit': limit, 'skip': skip},
      );
      final List recipesJson = response.data['recipes'] ?? [];
      return recipesJson.map((json) => Recipe.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final response = await _dio.get(
        ApiConstants.searchEndpoint,
        queryParameters: {'q': query},
      );
      final List recipesJson = response.data['recipes'] ?? [];
      return recipesJson.map((json) => Recipe.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Recipe> createRecipe(Recipe recipe) async {
    try {
      final response = await _dio.post(
        ApiConstants.addRecipeEndpoint,
        data: recipe.toJson(),
      );
      return Recipe.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Recipe> updateRecipe(Recipe recipe) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.recipesEndpoint}/${recipe.id}',
        data: {
          'name': recipe.name,
          'cuisine': recipe.cuisine,
          'difficulty': recipe.difficulty,
        },
      );
      return Recipe.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<bool> deleteRecipe(int id) async {
    try {
      final response = await _dio.delete('${ApiConstants.recipesEndpoint}/$id');
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return 'No internet connection or request timed out.';
    }
    return 'API Error: ${e.response?.statusCode ?? 'Unknown error'}';
  }
}
