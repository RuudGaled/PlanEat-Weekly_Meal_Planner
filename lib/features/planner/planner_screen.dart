import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/constants.dart';
import 'planner_provider.dart';
import 'models/meal_slot.dart';

class PlannerScreen extends ConsumerWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekPlan = ref.watch(plannerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pianificazione Settimanale')),
      drawer: const _MainDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: isWide ? constraints.maxWidth : 800,
              ),
              child: Table(
                border: TableBorder.all(color: Colors.grey.shade300),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _buildHeaderRow(),
                  for (final type in MealType.values)
                    _buildMealRow(type, weekPlan, ref, context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      children: [
        const TableCell(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text('Pasto', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        for (final day in Constants.weekdays)
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                day,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  TableRow _buildMealRow(
    MealType type,
    var weekPlan,
    WidgetRef ref,
    BuildContext context,
  ) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              _mealLabel(type),
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        for (final day in Constants.weekdays)
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ElevatedButton(
                onPressed: () {
                  //
                  //
                  //
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tocca $day – ${_mealLabel(type)}')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade50,
                ),
                child: Text(
                  weekPlan.days[day]!.meals
                          .firstWhere((m) => m.type == type)
                          .recipe
                          ?.title ??
                      'Aggiungi',
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _mealLabel(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return 'Colazione';
      case MealType.lunch:
        return 'Pranzo';
      case MealType.dinner:
        return 'Cena';
    }
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
