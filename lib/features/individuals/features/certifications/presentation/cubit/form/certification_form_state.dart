import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/individuals/features/basic_info/presentation/cubit/basic_info_cubit.dart';

class CertificationFormState extends Equatable {
  final String name;
  final String issuingInstitution;
  final DateTime? issueDate;
  final DateTime? expirationDate;
  final File? credentialFile;
  final FormStatus status;
  final String? errorMessage;

  const CertificationFormState({
    this.name = '',
    this.issuingInstitution = '',
    this.issueDate,
    this.expirationDate,
    this.credentialFile,
    this.status = FormStatus.initial,
    this.errorMessage,
  });

  CertificationFormState copyWith({
    String? name,
    String? issuingInstitution,
    DateTime? issueDate,
    DateTime? expirationDate,
    File? credentialFile,
    FormStatus? status,
    String? errorMessage,
  }) {
    return CertificationFormState(
      name: name ?? this.name,
      issuingInstitution: issuingInstitution ?? this.issuingInstitution,
      issueDate: issueDate ?? this.issueDate,
      expirationDate: expirationDate ?? this.expirationDate,
      credentialFile: credentialFile ?? this.credentialFile,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    name,
    issuingInstitution,
    issueDate,
    expirationDate,
    credentialFile,
    status,
    errorMessage,
  ];
}
