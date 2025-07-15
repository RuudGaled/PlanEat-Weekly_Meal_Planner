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
    // builder: (_) => RecipeSelectionSheet(day: day, type: mealType),
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.9,
      child: RecipeSelectionSheet(day: day, type: mealType),
    ),
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
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
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Drag handle
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(top: 12, bottom: 12),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: asyncRecipes.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Errore: $err')),
            data: (recipes) {
              // final favoriteRecipes = ref.watch(favoritesProvider);

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                children: [
                  Text(
                    'Seleziona una ricetta per ${_mealLabel(type)}',
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  for (final recipe in recipes)
                    RecipeListTile(recipe: recipe, day: day, type: type),
                ],
              );
            },
          ),
        ),
      ],
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

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      // elevation: 1,
      surfaceTintColor: colorScheme.surfaceContainerHighest,
      child: ListTile(
        // leading: Image.network(
        //   recipe.imageUrl,
        //   width: 50,
        //   height: 50,
        //   fit: BoxFit.cover,
        // ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            recipe.imageUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(recipe.title, style: textTheme.bodyMedium),
        trailing: IconButton(
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? Colors.red : colorScheme.onSurfaceVariant,
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
