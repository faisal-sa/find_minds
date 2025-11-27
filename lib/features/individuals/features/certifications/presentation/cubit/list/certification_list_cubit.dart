import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/individuals/features/certifications/domain/usecases/delete_certification_usecase.dart';
import 'package:graduation_project/features/individuals/features/certifications/domain/usecases/get_certifications_usecase.dart';
import 'package:graduation_project/features/individuals/features/certifications/presentation/cubit/list/certification_list_state.dart';
import 'package:graduation_project/features/individuals/features/work_experience/presentation/cubit/list/work_experience_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CertificationListCubit extends Cubit<CertificationListState> {
  final GetCertificationsUseCase _getCertificationsUseCase;
  final DeleteCertificationUseCase _deleteCertificationUseCase;

  CertificationListCubit(
    this._getCertificationsUseCase,
    this._deleteCertificationUseCase,
  ) : super(const CertificationListState());

  Future<void> loadCertifications() async {
    emit(const CertificationListState(status: ListStatus.loading));
    try {
      final list = await _getCertificationsUseCase();
      emit(
        CertificationListState(
          status: ListStatus.success,
          certifications: list,
        ),
      );
    } catch (e) {
      emit(
        CertificationListState(
          status: ListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteCertification(String id) async {
    try {
      await _deleteCertificationUseCase(id);
      await loadCertifications();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
