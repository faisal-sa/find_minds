import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/individuals/features/skills_languages/domain/entities/skills_and_languages_entity.dart';
import 'package:graduation_project/features/individuals/features/skills_languages/domain/repositories/skills_languages_repository.dart';
import 'package:graduation_project/features/individuals/features/skills_languages/presentation/cubit/skills_languages_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SkillsLanguagesCubit extends Cubit<SkillsLanguagesState> {
  final SkillsLanguagesRepository _repository;

  SkillsLanguagesCubit(this._repository) : super(SkillsLanguagesInitial());

  // 1. Initialize from UserEntity (no API call)
  void initialize(List<String> skills, List<String> languages) {
    // We create a container object. ID is empty because we don't need it
    // for local updates if the Repo handles getting the User ID.
    emit(
      SkillsLanguagesLoaded(
        SkillsAndLanguages(
          id: '',
          skills: List<String>.from(skills), // Safe copy
          languages: List<String>.from(languages), // Safe copy
        ),
      ),
    );
  }

  // 2. Fetch fresh data from API (Optional pull-to-refresh)
  Future<void> loadProfile() async {
    emit(SkillsLanguagesLoading());
    final result = await _repository.getData();

    result.fold(
      (failure) => emit(SkillsLanguagesError(failure.message)),
      (profile) => emit(SkillsLanguagesLoaded(profile)),
    );
  }

  // ========================== SKILLS LOGIC ==========================

  Future<void> addSkill(String newSkill) async {
    if (state is! SkillsLanguagesLoaded) return;
    
    // 1. Capture current state for rollback
    final currentState = (state as SkillsLanguagesLoaded);
    final currentData = currentState.skillsLanguages;

    // 2. Validation: Prevent duplicates
    if (currentData.skills.contains(newSkill)) return;

    // 3. Create new List (Safe for Windows)
    final updatedSkills = List<String>.from(currentData.skills)..add(newSkill);

    // 4. Optimistic Update (Update UI immediately)
    emit(
      SkillsLanguagesLoaded(
        SkillsAndLanguages(
          id: currentData.id,
          skills: updatedSkills,
          languages: currentData.languages,
        ),
      ),
    );

    // 5. Call Repository
    final result = await _repository.updateSkills(updatedSkills);

    // 6. Handle Error (Revert state)
    result.fold(
      (failure) {
        emit(SkillsLanguagesError(failure.message)); // Show error
        emit(currentState); // Revert UI
      },
      (_) {
        // Success: Do nothing, UI is already correct.
      },
    );
  }

  Future<void> removeSkill(String skillToRemove) async {
    if (state is! SkillsLanguagesLoaded) return;

    final currentState = (state as SkillsLanguagesLoaded);
    final currentData = currentState.skillsLanguages;

    final updatedSkills = List<String>.from(currentData.skills)
      ..remove(skillToRemove);

    emit(
      SkillsLanguagesLoaded(
        SkillsAndLanguages(
          id: currentData.id,
          skills: updatedSkills,
          languages: currentData.languages,
        ),
      ),
    );

    final result = await _repository.updateSkills(updatedSkills);

    result.fold((failure) {
      emit(SkillsLanguagesError(failure.message));
      emit(currentState);
    }, (_) => null);
  }

  // ========================== LANGUAGES LOGIC ==========================

  Future<void> addLanguage(String newLanguage) async {
    if (state is! SkillsLanguagesLoaded) return;

    final currentState = (state as SkillsLanguagesLoaded);
    final currentData = currentState.skillsLanguages;

    if (currentData.languages.contains(newLanguage)) return;

    // Create new list safely
    final updatedLanguages = List<String>.from(currentData.languages)
      ..add(newLanguage);

    // Optimistic Update
    emit(
      SkillsLanguagesLoaded(
        SkillsAndLanguages(
          id: currentData.id,
          skills: currentData.skills,
          languages: updatedLanguages,
        ),
      ),
    );

    final result = await _repository.updateLanguages(updatedLanguages);

    result.fold(
      (failure) {
        emit(SkillsLanguagesError(failure.message));
      emit(currentState); // Revert
      },
      (_) => null,
    );
  }

  Future<void> removeLanguage(String languageToRemove) async {
    if (state is! SkillsLanguagesLoaded) return;

    final currentState = (state as SkillsLanguagesLoaded);
    final currentData = currentState.skillsLanguages;

    final updatedLanguages = List<String>.from(currentData.languages)
      ..remove(languageToRemove);

    emit(
      SkillsLanguagesLoaded(
        SkillsAndLanguages(
          id: currentData.id,
          skills: currentData.skills,
          languages: updatedLanguages,
        ),
      ),
    );

    final result = await _repository.updateLanguages(updatedLanguages);

    result.fold((failure) {
      emit(SkillsLanguagesError(failure.message));
      emit(currentState);
    }, (_) => null);
  }
}
