import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/individuals/features/education/domain/entities/education.dart';
import 'package:graduation_project/features/individuals/features/education/domain/usecases/add_education_usecase.dart';
import 'package:graduation_project/features/individuals/features/education/domain/usecases/update_education_usecase.dart';
import 'package:injectable/injectable.dart';
import 'education_form_state.dart';

@injectable
class EducationFormCubit extends Cubit<EducationFormState> {
  final AddEducationUseCase _addUseCase;
  final UpdateEducationUseCase _updateUseCase;

  String? _editingId;

  EducationFormCubit(this._addUseCase, this._updateUseCase)
    : super(const EducationFormState());

  void initializeForEdit(Education education) {
    _editingId = education.id;
    emit(
      state.copyWith(
        degreeType: education.degreeType,
        institutionName: education.institutionName,
        fieldOfStudy: education.fieldOfStudy,
        startDate: education.startDate,
        endDate: education.endDate,
        gpa: education.gpa,
        activities: education.activities,
        graduationCertificate: education.graduationCertificate,
        academicRecord: education.academicRecord,
        status: FormStatus.initial,
      ),
    );
  }

  void degreeTypeChanged(String val) => emit(state.copyWith(degreeType: val));
  void institutionNameChanged(String val) =>
      emit(state.copyWith(institutionName: val));
  void fieldOfStudyChanged(String val) =>
      emit(state.copyWith(fieldOfStudy: val));
  void gpaChanged(String val) => emit(state.copyWith(gpa: val));
  void startDateChanged(DateTime date) => emit(state.copyWith(startDate: date));
  void endDateChanged(DateTime date) => emit(state.copyWith(endDate: date));

  // Placeholder logic for files - usually triggered by a file picker in UI
  void setGraduationCertificate(File? file) =>
      emit(state.copyWith(graduationCertificate: file));
  void setAcademicRecord(File? file) =>
      emit(state.copyWith(academicRecord: file));

  void addActivity(String item) {
    if (item.trim().isNotEmpty) {
      emit(
        state.copyWith(
          activities: List.from(state.activities)..add(item.trim()),
        ),
      );
    }
  }

  void removeActivity(int index) => emit(
    state.copyWith(activities: List.from(state.activities)..removeAt(index)),
  );

  Future<void> submitForm() async {
    if (state.degreeType.isEmpty ||
        state.institutionName.isEmpty ||
        state.fieldOfStudy.isEmpty ||
        state.startDate == null ||
        state.endDate == null) {
      emit(
        state.copyWith(
          status: FormStatus.failure,
          errorMessage: "Missing required fields",
        ),
      );
      return;
    }

    emit(state.copyWith(status: FormStatus.loading));

    try {
      final education = Education(
        id: _editingId ?? '',
        degreeType: state.degreeType,
        institutionName: state.institutionName,
        fieldOfStudy: state.fieldOfStudy,
        startDate: state.startDate!,
        endDate: state.endDate!,
        gpa: state.gpa,
        activities: state.activities,
        graduationCertificate: state.graduationCertificate,
        academicRecord: state.academicRecord,
      );

      if (_editingId != null) {
        await _updateUseCase(education);
      } else {
        await _addUseCase(education);
      }

      emit(state.copyWith(status: FormStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: FormStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
