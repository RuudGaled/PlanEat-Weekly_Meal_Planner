import 'recipe.dart';

enum MealType { breakfast, lunch, dinner }

class MealSlot {
  final MealType type;
  final Recipe? recipe;

  MealSlot({required this.type, this.recipe});

  MealSlot copyWith({Recipe? recipe}) => MealSlot(type: type, recipe: recipe);
}
