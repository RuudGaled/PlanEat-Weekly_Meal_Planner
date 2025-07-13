import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../favorites/favorites_provider.dart';
import '../planner/models/meal_slot.dart';
import '../planner/models/recipe.dart';
import '../planner/planner_provider.dart';
// import 'mock_recipes.dart';
import 'recipes_provider.dart';

void showRecipeSelectionSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String day,
  required MealType mealType,
}) {
  showModalBottomSheet(
    context: context,
    builder: (_) => RecipeSelectionSheet(day: day, type: mealType),
  );
}

class RecipeSelectionSheet extends ConsumerWidget {
  final String day;
  final MealType type;

  const RecipeSelectionSheet({
    super.key,
    required this.day,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRecipes = ref.watch(recipesProvider);

    return asyncRecipes.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Errore: $err')),
      data: (recipes) {
        // final favoriteRecipes = ref.watch(favoritesProvider);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Seleziona una ricetta per ${_mealLabel(type)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            for (final recipe in recipes)
              RecipeListTile(recipe: recipe, day: day, type: type),
          ],
        );
      },
    );
  }

  String _mealLabel(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return 'Colazione';
      case MealType.lunch:
        return 'Pranzo';
      case MealType.dinner:
        return 'Cena';
    }
  }
}

class RecipeListTile extends ConsumerWidget {
  final Recipe recipe;
  final String day;
  final MealType type;

  const RecipeListTile({
    super.key,
    required this.recipe,
    required this.day,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(
      favoritesProvider.select(
        (favorites) => favorites.any((r) => r.id == recipe.id),
      ),
    );

    return Card(
      child: ListTile(
        leading: Image.network(
          recipe.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(recipe.title),
        trailing: IconButton(
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () {
            ref.read(favoritesProvider.notifier).toggleFavorite(recipe);
          },
        ),
        onTap: () {
          ref
              .read(plannerProvider.notifier)
              .assignMeal(day: day, type: type, recipe: recipe);
          context.pop();
        },
      ),
    );
  }
}
