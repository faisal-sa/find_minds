import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/individuals/features/education/domain/usecases/delete_education_usecase.dart';
import 'package:graduation_project/features/individuals/features/education/domain/usecases/get_educations_usecase.dart';
import 'package:injectable/injectable.dart';
import 'education_list_state.dart';

@injectable
class EducationListCubit extends Cubit<EducationListState> {
  final GetEducationsUseCase _getEducationsUseCase;
  final DeleteEducationUseCase _deleteEducationUseCase;

  EducationListCubit(this._getEducationsUseCase, this._deleteEducationUseCase)
    : super(const EducationListState());

  Future<void> loadEducations() async {
    emit(const EducationListState(status: ListStatus.loading));
    try {
      final list = await _getEducationsUseCase();
      emit(EducationListState(status: ListStatus.success, educations: list));
    } catch (e) {
      emit(
        EducationListState(
          status: ListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteEducation(String id) async {
    try {
      await _deleteEducationUseCase(id);
      await loadEducations();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
