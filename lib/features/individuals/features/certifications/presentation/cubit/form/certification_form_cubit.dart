import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/individuals/features/basic_info/presentation/cubit/basic_info_cubit.dart';
import 'package:graduation_project/features/individuals/features/certifications/domain/entities/certification.dart';
import 'package:graduation_project/features/individuals/features/certifications/domain/usecases/add_certification_usecase.dart';
import 'package:graduation_project/features/individuals/features/certifications/domain/usecases/update_certification_usecase.dart';
import 'package:graduation_project/features/individuals/features/certifications/presentation/cubit/form/certification_form_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CertificationFormCubit extends Cubit<CertificationFormState> {
  final AddCertificationUseCase _addUseCase;
  final UpdateCertificationUseCase _updateUseCase;

  String? _editingId;

  CertificationFormCubit(this._addUseCase, this._updateUseCase)
    : super(const CertificationFormState());

  void initializeForEdit(Certification cert) {
    _editingId = cert.id;
    emit(
      state.copyWith(
        name: cert.name,
        issuingInstitution: cert.issuingInstitution,
        issueDate: cert.issueDate,
        expirationDate: cert.expirationDate,
        credentialFile: cert.credentialFile,
        status: FormStatus.initial,
      ),
    );
  }

  void nameChanged(String val) => emit(state.copyWith(name: val));
  void issuingInstitutionChanged(String val) =>
      emit(state.copyWith(issuingInstitution: val));
  void issueDateChanged(DateTime date) => emit(state.copyWith(issueDate: date));
  void expirationDateChanged(DateTime date) =>
      emit(state.copyWith(expirationDate: date));

  void setCredentialFile(File? file) =>
      emit(state.copyWith(credentialFile: file));

  Future<void> submitForm() async {
    // Validate required fields
    if (state.name.isEmpty ||
        state.issuingInstitution.isEmpty ||
        state.issueDate == null) {
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
      final cert = Certification(
        id: _editingId ?? '',
        name: state.name,
        issuingInstitution: state.issuingInstitution,
        issueDate: state.issueDate!,
        expirationDate: state.expirationDate,
        credentialFile: state.credentialFile,
      );

      if (_editingId != null) {
        await _updateUseCase(cert);
      } else {
        await _addUseCase(cert);
      }

      emit(state.copyWith(status: FormStatus.success));
    } catch (e) {
      emit(
        state.copyWith(status: FormStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
