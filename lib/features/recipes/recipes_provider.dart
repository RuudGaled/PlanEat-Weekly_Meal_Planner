import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../planner/models/recipe.dart';

final recipesProvider = FutureProvider<List<Recipe>>((ref) async {
  const url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Errore durante il caricamento delle ricette');
  }

  final data = json.decode(response.body);
  final List<dynamic> meals = data['meals'];

  return meals.map((json) => Recipe.fromJson(json)).toList();
});
