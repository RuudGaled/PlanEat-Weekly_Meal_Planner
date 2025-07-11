import 'day_plan.dart';

class WeekPlan {
  final Map<String, DayPlan> days;

  WeekPlan({required this.days});

  factory WeekPlan.empty() {
    return WeekPlan(
      days: {
        'Lun': DayPlan.empty(),
        'Mar': DayPlan.empty(),
        'Mer': DayPlan.empty(),
        'Gio': DayPlan.empty(),
        'Ven': DayPlan.empty(),
        'Sab': DayPlan.empty(),
        'Dom': DayPlan.empty(),
      },
    );
  }

  WeekPlan copyWith({Map<String, DayPlan>? days}) {
    return WeekPlan(days: days ?? this.days);
  }
}
