import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../planner/models/recipe.dart';

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Recipe>>((ref) {
      return FavoritesNotifier();
    });

class FavoritesNotifier extends StateNotifier<List<Recipe>> {
  static const _prefsKey = 'favorite_recipes';

  FavoritesNotifier() : super([]) {
    _loadFromPrefs();
  }

  void toggleFavorite(Recipe recipe) {
    final exists = state.any((r) => r.id == recipe.id);
    final updated = exists
        ? state.where((r) => r.id != recipe.id).toList()
        : [...state, recipe];

    state = updated;
    _saveToPrefs();
  }

  bool isFavorite(String id) {
    return state.any((r) => r.id == id);
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(state.map((r) => r.toJson()).toList());
    await prefs.setString(_prefsKey, encoded);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_prefsKey);

    if (data != null) {
      final decoded = jsonDecode(data) as List;
      state = decoded.map((e) => Recipe.fromJson(e)).toList();
    }
  }
}
