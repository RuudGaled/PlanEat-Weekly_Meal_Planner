import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/constants.dart';

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pianificazione Settimanale')),
      drawer: const _MainDrawer(),
      body: const Center(child: Text('Planner in costruzione...')),
    );
  }
}

class _MainDrawer extends StatelessWidget {
  const _MainDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text(Constants.appName)),
          ListTile(title: const Text('Planner'), onTap: () => context.go('/')),
          ListTile(
            title: const Text('Ricette'),
            onTap: () => context.go('/recipes'),
          ),
          ListTile(
            title: const Text('Preferiti'),
            onTap: () => context.go('/favorites'),
          ),
          ListTile(
            title: const Text('Lista spesa'),
            onTap: () => context.go('/shopping'),
          ),
          ListTile(
            title: const Text('Impostazioni'),
            onTap: () => context.go('/settings'),
          ),
        ],
      ),
    );
  }
}
