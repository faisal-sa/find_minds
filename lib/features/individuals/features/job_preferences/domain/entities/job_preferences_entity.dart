import 'package:equatable/equatable.dart';

class JobPreferencesEntity extends Equatable {
  final List<String> targetRoles;
  final int? minSalary;
  final int? maxSalary;
  final String? salaryCurrency;
  final String? currentWorkStatus; // Could be an Enum in real app
  final List<String> employmentTypes; // Full-time, Part-time...
  final List<String> workModes; // Remote, Onsite...
  final bool canRelocate;
  final bool canStartImmediately;
  final int? noticePeriodDays;

  const JobPreferencesEntity({
    this.targetRoles = const [],
    this.minSalary,
    this.maxSalary,
    this.salaryCurrency,
    this.currentWorkStatus,
    this.employmentTypes = const [],
    this.workModes = const [],
    this.canRelocate = false,
    this.canStartImmediately = false,
    this.noticePeriodDays,
  });

  @override
  List<Object?> get props => [
    targetRoles,
    minSalary,
    maxSalary,
    salaryCurrency,
    currentWorkStatus,
    employmentTypes,
    workModes,
    canRelocate,
    canStartImmediately,
    noticePeriodDays,
  ];
}
