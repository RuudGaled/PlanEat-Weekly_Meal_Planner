import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'checked_items_provider.dart';
import 'shopping_list_provider.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(shoppingListProvider);
    final checkedItems = ref.watch(checkedItemsProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista della Spesa', style: textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Torna alla home',
          onPressed: () => context.go('/'),
        ),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                'Nessun ingrediente disponibile.',
                style: textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];
                final isChecked = checkedItems.contains(item);

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CheckboxListTile(
                    value: isChecked,
                    onChanged: (_) =>
                        ref.read(checkedItemsProvider.notifier).toggle(item),
                    title: Text(
                      item,
                      style: textTheme.bodyMedium?.copyWith(
                        decoration: isChecked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: isChecked
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurface,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: colorScheme.primary,
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 4),
            ),
    );
  }
}
