import '../../../core/utils/constants.dart';
import 'day_plan.dart';

class WeekPlan {
  final Map<String, DayPlan> days;

  WeekPlan({required this.days});

  factory WeekPlan.empty() {
    final dayMap = {for (final day in Constants.weekdays) day: DayPlan.empty()};
    return WeekPlan(days: dayMap);
  }

  WeekPlan copyWith({Map<String, DayPlan>? days}) {
    return WeekPlan(days: days ?? this.days);
  }
}
