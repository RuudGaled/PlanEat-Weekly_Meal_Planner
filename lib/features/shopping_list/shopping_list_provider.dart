import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../planner/planner_provider.dart';

final shoppingListProvider = Provider<List<String>>((ref) {
  final weekPlan = ref.watch(plannerProvider);

  final allIngredients = <String>[];

  for (final dayPlan in weekPlan.days.values) {
    for (final meal in dayPlan.meals) {
      final recipe = meal.recipe;
      if (recipe != null && recipe.ingredients.isNotEmpty) {
        allIngredients.addAll(recipe.ingredients);
      }
    }
  }

  // final unique = allIngredients.toSet().toList()..sort();
  final unique =
      allIngredients.where((i) => i.trim().isNotEmpty).toSet().toList()..sort();

  return unique;
});
