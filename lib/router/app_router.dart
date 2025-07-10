import 'package:go_router/go_router.dart';
import '../features/planner/planner_screen.dart';
import '../features/recipes/recipes_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/shopping_list/shopping_list_screen.dart';
import '../features/settings/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PlannerScreen(),
    ),
    GoRoute(
      path: '/recipes',
      builder: (context, state) => const RecipesScreen(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/shopping',
      builder: (context, state) => const ShoppingListScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
