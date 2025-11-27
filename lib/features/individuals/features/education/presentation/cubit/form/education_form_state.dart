import 'dart:io';
import 'package:equatable/equatable.dart';

enum FormStatus { initial, loading, success, failure }

class EducationFormState extends Equatable {
  final String degreeType;
  final String institutionName;
  final String fieldOfStudy;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? gpa;
  final List<String> activities;
  final File? graduationCertificate;
  final File? academicRecord;
  final FormStatus status;
  final String? errorMessage;

  const EducationFormState({
    this.degreeType = '',
    this.institutionName = '',
    this.fieldOfStudy = '',
    this.startDate,
    this.endDate,
    this.gpa,
    this.activities = const [],
    this.graduationCertificate,
    this.academicRecord,
    this.status = FormStatus.initial,
    this.errorMessage,
  });

  EducationFormState copyWith({
    String? degreeType,
    String? institutionName,
    String? fieldOfStudy,
    DateTime? startDate,
    DateTime? endDate,
    String? gpa,
    List<String>? activities,
    File? graduationCertificate,
    File? academicRecord,
    FormStatus? status,
    String? errorMessage,
  }) {
    return EducationFormState(
      degreeType: degreeType ?? this.degreeType,
      institutionName: institutionName ?? this.institutionName,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      gpa: gpa ?? this.gpa,
      activities: activities ?? this.activities,
      graduationCertificate:
          graduationCertificate ?? this.graduationCertificate,
      academicRecord: academicRecord ?? this.academicRecord,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    degreeType,
    institutionName,
    fieldOfStudy,
    startDate,
    endDate,
    gpa,
    activities,
    graduationCertificate,
    academicRecord,
    status,
    errorMessage,
  ];
}
