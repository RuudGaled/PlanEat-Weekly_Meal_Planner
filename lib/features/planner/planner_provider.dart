import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/day_plan.dart';
import 'models/week_plan.dart';
import 'models/recipe.dart';
import 'models/meal_slot.dart';

final plannerProvider = StateNotifierProvider<PlannerNotifier, WeekPlan>((ref) {
  return PlannerNotifier();
});

class PlannerNotifier extends StateNotifier<WeekPlan> {
  PlannerNotifier() : super(WeekPlan.empty());

  void assignMeal({
    required String day,
    required MealType type,
    required Recipe recipe,
  }) {
    final currentDay = state.days[day] ?? DayPlan.empty();
    
    final updatedMeals = currentDay.meals.map((slot) {
      if (slot.type == type) {
        return slot.copyWith(recipe: recipe);
      }
      return slot;
    }).toList();

    final updatedDayPlan = currentDay.copyWith(meals: updatedMeals);
    final updatedDays = {...state.days, day: updatedDayPlan};

    state = state.copyWith(days: updatedDays);
  }

  void clearAll() {
    state = WeekPlan.empty();
  }
}
