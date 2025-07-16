import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/week_plan.dart';
import '../planner_provider.dart';
import '../models/meal_slot.dart';
import '../../../core/utils/constants.dart';
import '../../recipes/recipe_selection_sheet.dart';

class PlannerDesktop extends StatelessWidget {
  final WidgetRef ref;

  const PlannerDesktop({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    final weekPlan = ref.watch(plannerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                for (final type in MealType.values)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _mealLabel(type),
                      style: textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            for (final day in Constants.weekdays)
              _DayColumn(
                day: day,
                weekPlan: weekPlan,
                ref: ref,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
          ],
        ),
      ),
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

class _DayColumn extends StatelessWidget {
  final String day;
  final WeekPlan weekPlan;
  final WidgetRef ref;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _DayColumn({
    required this.day,
    required this.weekPlan,
    required this.ref,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final dayPlan = weekPlan.days[day]!;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 120, maxWidth: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: colorScheme.primaryContainer,
            child: Text(
              day,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          for (final slot in dayPlan.meals)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ElevatedButton(
                onPressed: () {
                  showRecipeSelectionSheet(
                    context: context,
                    ref: ref,
                    day: day,
                    mealType: slot.type,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondaryContainer,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: slot.recipe == null
                      ? Center(
                          child: Text(
                            'Aggiungi',
                            style: textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                slot.recipe!.title,
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 16),
                              tooltip: 'Rimuovi ricetta',
                              onPressed: () {
                                ref
                                    .read(plannerProvider.notifier)
                                    .removeMeal(day: day, type: slot.type);
                              },
                            ),
                          ],
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
