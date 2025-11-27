import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/individuals/features/certifications/domain/entities/certification.dart';
import 'package:graduation_project/features/individuals/features/work_experience/presentation/cubit/list/work_experience_list_state.dart';

class CertificationListState extends Equatable {
  final ListStatus status;
  final List<Certification> certifications;
  final String? errorMessage;

  const CertificationListState({
    this.status = ListStatus.initial,
    this.certifications = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, certifications, errorMessage];
}
