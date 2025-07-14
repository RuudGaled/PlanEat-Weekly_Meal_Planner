import 'meal_slot.dart';

class DayPlan {
  final List<MealSlot> meals;

  DayPlan({required this.meals});

  factory DayPlan.empty() {
    return DayPlan(
      meals: MealType.values.map((type) => MealSlot(type: type)).toList(),
    );
  }

  DayPlan copyWith({List<MealSlot>? meals}) {
    return DayPlan(meals: meals ?? this.meals);
  }

  Map<String, dynamic> toJson() => {
    'meals': meals.map((m) => m.toJson()).toList(),
  };

  factory DayPlan.fromJson(Map<String, dynamic> json, {bool saved = false}) {
    return DayPlan(
      meals: (json['meals'] as List)
          .map((m) => MealSlot.fromJson(m, saved: saved))
          .toList(),
    );
  }
}
