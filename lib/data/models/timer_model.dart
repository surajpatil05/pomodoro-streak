class TimerModel {
  final int focusTime;
  final int breakTime;
  final int cyclesToday;
  final int cyclesThisWeek;
  final int cyclesThisMonth;
  final int totalCycles;
  final int timeSpentToday;
  final int timeSpentThisWeek;
  final int timeSpentThisMonth;
  final int totalTimeSpent;
  final DateTime timestamp;

  TimerModel({
    required this.focusTime,
    required this.breakTime,
    required this.cyclesToday,
    required this.cyclesThisWeek,
    required this.cyclesThisMonth,
    required this.totalCycles,
    required this.timeSpentToday,
    required this.timeSpentThisWeek,
    required this.timeSpentThisMonth,
    required this.totalTimeSpent,
    required this.timestamp,
  });

  // The copyWith method for TimerModel
  TimerModel copyWith({
    int? focusTime,
    int? breakTime,
    int? cyclesToday,
    int? cyclesThisWeek,
    int? cyclesThisMonth,
    int? totalCycles,
    int? timeSpentToday,
    int? timeSpentThisWeek,
    int? timeSpentThisMonth,
    int? totalTimeSpent,
    DateTime? timestamp,
  }) {
    return TimerModel(
      focusTime: focusTime ?? this.focusTime,
      breakTime: breakTime ?? this.breakTime,
      cyclesToday: cyclesToday ?? this.cyclesToday,
      cyclesThisWeek: cyclesThisWeek ?? this.cyclesThisWeek,
      cyclesThisMonth: cyclesThisMonth ?? this.cyclesThisMonth,
      totalCycles: totalCycles ?? this.totalCycles,
      timeSpentToday: timeSpentToday ?? this.timeSpentToday,
      timeSpentThisWeek: timeSpentThisWeek ?? this.timeSpentThisWeek,
      timeSpentThisMonth: timeSpentThisMonth ?? this.timeSpentThisMonth,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    return TimerModel(
      cyclesToday: json['cycle_count'] ?? 0, // Matches database column
      timeSpentToday: json['time_spent'] ?? 0, // Matches database column
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp']) // Ensure valid date parsing
          : DateTime.now(),

      // Default values for non-database fields
      focusTime: 25 * 60,
      breakTime: 5 * 60,
      cyclesThisWeek: 0,
      cyclesThisMonth: 0,
      totalCycles: 0,
      timeSpentThisWeek: 0,
      timeSpentThisMonth: 0,
      totalTimeSpent: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cycle_count': cyclesToday, // Stored in database
      'time_spent': timeSpentToday, // Stored in database
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
