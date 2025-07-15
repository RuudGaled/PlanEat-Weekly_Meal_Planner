import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'shopping_list_provider.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(shoppingListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista della Spesa'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: items.isEmpty
          ? const Center(child: Text('Nessun ingrediente disponibile.'))
          : ListView.separated(
              // padding: const EdgeInsets.all(16),
              // itemCount: items.length,
              // separatorBuilder: (_, __) => const Divider(),
              // itemBuilder: (_, index) {
              //   return ListTile(title: Text(items[index]));
              // },
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: items.length,
              itemBuilder: (_, index) => ListTile(
                leading: Icon(
                  Icons.check_box_outline_blank,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(items[index]),
              ),
              separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
            ),
    );
  }
}
