import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/constants.dart';
import '../../recipes/recipe_selection_sheet.dart';
import '../planner_provider.dart';
import '../models/meal_slot.dart';

class PlannerMobilePortrait extends StatelessWidget {
  final WidgetRef ref;

  const PlannerMobilePortrait({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    final weekPlan = ref.watch(plannerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: Constants.weekdays.length,
      itemBuilder: (context, dayIndex) {
        final day = Constants.weekdays[dayIndex];
        final dayPlan = weekPlan.days[day]!;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                color: colorScheme.primaryContainer,
                child: Text(day, style: textTheme.titleMedium),
              ),
              for (final slot in dayPlan.meals)
                ListTile(
                  title: Text(_mealLabel(slot.type)),
                  subtitle: Text(
                    slot.recipe?.title ?? 'Aggiungi',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: slot.recipe != null
                      ? IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          tooltip: 'Rimuovi ricetta',
                          onPressed: () {
                            ref
                                .read(plannerProvider.notifier)
                                .removeMeal(day: day, type: slot.type);
                          },
                        )
                      : const Icon(Icons.fastfood),
                  onTap: () => showRecipeSelectionSheet(
                    context: context,
                    ref: ref,
                    day: day,
                    mealType: slot.type,
                  ),
                ),
            ],
          ),
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
