import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';

class CounterTabViewModel extends ChangeNotifier {
  UserInfoUsecases userInfoUsecases;

  CounterTabViewModel(this.userInfoUsecases);

  UserInfoEntity get userInfoEntity => userInfoUsecases.userInfoEntity;

  DateTime? get ordDate => userInfoEntity.ordDate;
  DateTime? get enlistmentDate => userInfoEntity.enlistmentDate;
  DateTime get now => DateTime.now();
  DateTime get today => DateTime(now.year, now.month, now.day);

  // Calculate percentage elapsed from enlistment to ORD
  int? get totalDays => ordDate != null && enlistmentDate != null
      ? ordDate!.difference(enlistmentDate!).inDays
      : null;
  int? get elapsedDays => ordDate != null && enlistmentDate != null
      ? today.difference(enlistmentDate!).inDays
      : null;
  int? get remainingDays => ordDate != null && enlistmentDate != null
      ? ordDate!.difference(today).inDays
      : null;
  double? get percentElapsed {
    if (totalDays == null || elapsedDays == null) return null;
    return totalDays! > 0
        ? (elapsedDays!.clamp(0, totalDays!) / totalDays!)
        : null;
  }
  // int? elapsedDays;
  // int? remainingDays;
  // double? percentElapsed = 0;
  // if (ordDate != null && enlistmentDate != null) {
  //   totalDays = ordDate.difference(enlistmentDate).inDays;
  //   elapsedDays = today.difference(enlistmentDate).inDays;
  //   remainingDays = ordDate.difference(today).inDays;
  //   percentElapsed = totalDays > 0
  //       ? (elapsedDays.clamp(0, totalDays) / totalDays)
  //       : null;
  // }

  // Helper method to format a date as DD MMM YYYY
  String formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.day} ${getMonthName(date.month)} ${date.year}';
  }

  // Helper method to get month name
  String getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  // Helper method to calculate weekdays left
  int calculateWeekdaysLeft(DateTime from, DateTime? to) {
    if (to == null) return 0;
    int weekdaysCount = 0;
    DateTime current = DateTime(from.year, from.month, from.day);

    while (current.isBefore(to) || current.isAtSameMomentAs(to)) {
      // Weekdays are Monday (1) to Friday (5)
      if (current.weekday >= 1 && current.weekday <= 5) {
        weekdaysCount++;
      }
      current = current.add(const Duration(days: 1));
    }

    return weekdaysCount;
  }

  // Helper method to calculate weekends left
  int calculateWeekendsLeft(DateTime from, DateTime? to) {
    if (to == null) return 0;
    int weekendsCount = 0;
    DateTime current = DateTime(from.year, from.month, from.day);

    while (current.isBefore(to) || current.isAtSameMomentAs(to)) {
      // Weekends are Saturday (6) and Sunday (7)
      if (current.weekday == 6 || current.weekday == 7) {
        weekendsCount++;
      }
      current = current.add(const Duration(days: 1));
    }
    return weekendsCount;
  }
}
