import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/individuals/features/education/domain/entities/education.dart';

enum ListStatus { initial, loading, success, failure }

class EducationListState extends Equatable {
  final ListStatus status;
  final List<Education> educations;
  final String? errorMessage;

  const EducationListState({
    this.status = ListStatus.initial,
    this.educations = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, educations, errorMessage];
}
