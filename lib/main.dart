import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: PlanEatApp()));
}

class PlanEatApp extends StatelessWidget {
  const PlanEatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'PlanEat');
  }
}
