import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/day_plan.dart';
import 'models/week_plan.dart';
import 'models/recipe.dart';
import 'models/meal_slot.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


final plannerProvider = StateNotifierProvider<PlannerNotifier, WeekPlan>((ref) {
  return PlannerNotifier();
});

class PlannerNotifier extends StateNotifier<WeekPlan> {
  static const _storageKey = 'week_plan';

  PlannerNotifier() : super(WeekPlan.empty()) {
    _loadFromPrefs();
  }

  void assignMeal({
    required String day,
    required MealType type,
    required Recipe recipe,
  }) {
    final currentDay = state.days[day] ?? DayPlan.empty();

    final updatedMeals = currentDay.meals.map((slot) {
      return slot.type == type ? slot.copyWith(recipe: recipe) : slot;
    }).toList();

    final updatedDayPlan = currentDay.copyWith(meals: updatedMeals);
    final updatedDays = {...state.days, day: updatedDayPlan};

    state = state.copyWith(days: updatedDays);
    _saveToPrefs();
  }

  void clearAll() {
    state = WeekPlan.empty();
    _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(state.toJson());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString);
        state = WeekPlan.fromJson(jsonMap);
      } catch (_) {
        state = WeekPlan.empty();
      }
    }
  }
}