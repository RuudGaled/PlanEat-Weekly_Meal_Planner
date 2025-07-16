import 'package:go_router/go_router.dart';
import '../features/planner/planner_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/shopping_list/shopping_list_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const PlannerScreen()),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/shopping',
      builder: (context, state) => const ShoppingListScreen(),
    ),
  ],
);
