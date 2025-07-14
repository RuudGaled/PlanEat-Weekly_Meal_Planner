import 'recipe.dart';

enum MealType { breakfast, lunch, dinner }

class MealSlot {
  final MealType type;
  final Recipe? recipe;

  MealSlot({required this.type, this.recipe});

  MealSlot copyWith({Recipe? recipe}) => MealSlot(type: type, recipe: recipe);

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'recipe': recipe?.toJson(),
  };

  factory MealSlot.fromJson(Map<String, dynamic> json, {bool saved = false}) {
    return MealSlot(
      type: MealType.values.firstWhere((e) => e.name == json['type']),
      recipe: json['recipe'] != null
          ? (saved
                ? Recipe.fromSavedJson(json['recipe'])
                : Recipe.fromJson(json['recipe']))
          : null,
    );
  }
}
