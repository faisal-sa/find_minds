import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/individuals/features/work_experience/domain/entities/work_experience.dart';
import 'package:graduation_project/features/individuals/features/work_experience/domain/usecases/add_work_experience_usecase.dart';
import 'package:graduation_project/features/individuals/features/work_experience/domain/usecases/delete_work_experience_usecase.dart';
import 'package:graduation_project/features/individuals/features/work_experience/domain/usecases/get_work_experiences_usecase.dart';
import 'package:graduation_project/features/individuals/features/work_experience/domain/usecases/update_work_experience_usecase.dart';
import 'package:graduation_project/features/individuals/features/work_experience/presentation/cubit/list/work_experience_list_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class WorkExperienceListCubit extends Cubit<WorkExperienceListState> {
  final GetWorkExperiencesUseCase _getWorkExperiencesUseCase;
  final DeleteWorkExperienceUseCase _deleteWorkExperienceUseCase;
  final AddWorkExperienceUseCase _addWorkExperienceUseCase;
  final UpdateWorkExperienceUseCase _updateWorkExperienceUseCase;

  WorkExperienceListCubit(
    this._getWorkExperiencesUseCase,
    this._deleteWorkExperienceUseCase,
    this._addWorkExperienceUseCase,
    this._updateWorkExperienceUseCase,
  ) : super(const WorkExperienceListState());

  Future<void> loadExperiences() async {
    emit(const WorkExperienceListState(status: ListStatus.loading));
    try {
      final list = await _getWorkExperiencesUseCase();
      emit(
        WorkExperienceListState(status: ListStatus.success, experiences: list),
      );
    } catch (e) {
      emit(
        WorkExperienceListState(
          status: ListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addExperience(WorkExperience experience) async {
    try {
      await _addWorkExperienceUseCase(experience);
      final currentList = List<WorkExperience>.from(state.experiences);
      currentList.add(experience);
      emit(state.copyWith(experiences: currentList));
    } catch (e) {
      debugPrint(e.toString());
      // Optionally handle error state here
    }
  }

  Future<void> updateExperience(WorkExperience experience) async {
    try {
      await _updateWorkExperienceUseCase(experience);
      final currentList = List<WorkExperience>.from(state.experiences);
      final index = currentList.indexWhere((e) => e.id == experience.id);
      if (index != -1) {
        currentList[index] = experience;
        emit(state.copyWith(experiences: currentList));
      }
    } catch (e) {
      debugPrint(e.toString());
      // Optionally handle error state here
    }
  }

  Future<void> deleteExperience(String id) async {
    try {
      await _deleteWorkExperienceUseCase(id);
      final currentList = List<WorkExperience>.from(state.experiences);
      currentList.removeWhere((e) => e.id == id);
      emit(state.copyWith(experiences: currentList));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
