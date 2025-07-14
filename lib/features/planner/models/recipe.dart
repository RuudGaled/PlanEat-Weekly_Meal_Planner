class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> ingredients; // ← NEW

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.ingredients = const [],
  });

  factory Recipe.fromJson(Map<String, dynamic> json, {bool saved = false}) {
    final List<String> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient.toString().trim());
      }
    }

    return Recipe(
      id: json['idMeal'],
      title: json['strMeal'],
      imageUrl: json['strMealThumb'],
      ingredients: ingredients,
    );
  }

  Map<String, dynamic> toJson() => {
        'idMeal': id,
        'strMeal': title,
        'strMealThumb': imageUrl,
        'ingredients': ingredients,
      };

  factory Recipe.fromSavedJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['idMeal'],
      title: json['strMeal'],
      imageUrl: json['strMealThumb'],
      ingredients: List<String>.from(json['ingredients'] ?? []),
    );
  }
}
