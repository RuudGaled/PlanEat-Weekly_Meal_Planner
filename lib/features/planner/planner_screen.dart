import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/constants.dart';
import 'layouts/planner_responsive.dart';

class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pianificazione Settimanale', style: textTheme.titleLarge),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 0.5,
      ),
      drawer: const _MainDrawer(),
      body: const PlannerResponsive(),
    );
  }
}

class _MainDrawer extends StatelessWidget {
  const _MainDrawer();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primaryContainer),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                Constants.appName,
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          _DrawerItem(
            title: 'Planner',
            icon: Icons.calendar_today,
            selected: currentRoute == '/',
            onTap: () => context.go('/'),
          ),
          _DrawerItem(
            title: 'Preferiti',
            icon: Icons.favorite,
            selected: currentRoute == '/favorites',
            onTap: () => context.go('/favorites'),
          ),
          _DrawerItem(
            title: 'Lista spesa',
            icon: Icons.shopping_cart,
            selected: currentRoute == '/shopping',
            onTap: () => context.go('/shopping'),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  const _DrawerItem({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: selected ? colorScheme.primary : null),
      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(
          color: selected ? colorScheme.primary : null,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selected,
      selectedTileColor: colorScheme.primary.withOpacity(0.1),
      onTap: onTap,
    );
  }
}
