import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final checkedItemsProvider =
    StateNotifierProvider<CheckedItemsNotifier, Set<String>>((ref) {
      return CheckedItemsNotifier();
    });

class CheckedItemsNotifier extends StateNotifier<Set<String>> {
  static const _prefsKey = 'checked_items';

  CheckedItemsNotifier() : super({}) {
    _load();
  }

  void toggle(String item) {
    final updated = Set<String>.from(state);
    if (updated.contains(item)) {
      updated.remove(item);
    } else {
      updated.add(item);
    }
    state = updated;
    _save();
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_prefsKey, jsonEncode(state.toList()));
  }

  void _load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString != null) {
      try {
        final list = List<String>.from(jsonDecode(jsonString));
        state = list.toSet();
      } catch (_) {
        state = {};
      }
    }
  }
}
