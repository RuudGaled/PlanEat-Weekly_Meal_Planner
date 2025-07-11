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
}
