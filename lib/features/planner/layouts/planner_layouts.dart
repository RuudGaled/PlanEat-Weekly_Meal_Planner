import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../recipes/recipe_selection_sheet.dart';
import '../models/week_plan.dart';
import '../planner_provider.dart';
import '../models/meal_slot.dart';
import '../../../core/utils/constants.dart';

class PlannerResponsive extends ConsumerWidget {
  const PlannerResponsive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    if (width < 576) {
      return _PlannerMobilePortrait(ref: ref);
    } else if (width < 992) {
      // Se siamo in landscape ma ancora su un dispositivo stretto, usa comunque un layout mobile
      if (orientation == Orientation.landscape) {
        return _PlannerMobileLandscape(ref: ref);
      } else {
        return _PlannerMobilePortrait(ref: ref);
      }
    } else {
      return _PlannerDesktop(ref: ref);
    }
  }
}

class _PlannerDesktop extends StatelessWidget {
  final WidgetRef ref;

  const _PlannerDesktop({required this.ref});

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
            // Colonna dei tipi di pasto (Colazione, Pranzo, Cena)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48), // Spazio per allineare con header
                for (final type in MealType.values)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _mealLabel(type),
                      // style: const TextStyle(fontStyle: FontStyle.italic),
                      style: textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Colonne per ogni giorno
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
      // margin: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(minWidth: 120, maxWidth: 200),
      // width: 120, // oppure usa `Flexible`/`IntrinsicWidth` se vuoi dinamico
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
                                style: textTheme.labelMedium,
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

class _PlannerMobilePortrait extends StatelessWidget {
  final WidgetRef ref;

  const _PlannerMobilePortrait({required this.ref});

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
                  subtitle: Text(slot.recipe?.title ?? 'Aggiungi'),
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
}

class _PlannerMobileLandscape extends StatelessWidget {
  final WidgetRef ref;

  const _PlannerMobileLandscape({required this.ref});

  @override
  Widget build(BuildContext context) {
    final weekPlan = ref.watch(plannerProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: Constants.weekdays.length,
      itemBuilder: (context, dayIndex) {
        final day = Constants.weekdays[dayIndex];
        final dayPlan = weekPlan.days[day]!;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                color: colorScheme.primaryContainer,
                child: Text(day, style: textTheme.titleMedium),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  for (final slot in dayPlan.meals)
                    ListTile(
                      title: Text(_mealLabel(slot.type)),
                      subtitle: Text(slot.recipe?.title ?? 'Aggiungi'),
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
            ),
          ],
        );
      },
    );
  }
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
