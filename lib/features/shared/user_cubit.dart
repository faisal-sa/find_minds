// user_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/individuals/features/education/domain/entities/education.dart';
import 'package:graduation_project/features/individuals/features/work_experience/domain/entities/work_experience.dart';
import 'package:graduation_project/features/shared/user_entity.dart';
import 'package:graduation_project/features/shared/user_state.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  void setInitialUserData(UserEntity user) {
    emit(state.copyWith(user: user));
  }

  void updateBasicInfo({
    String? firstName,
    String? lastName,
    String? jobTitle,
    String? phone,
    String? email,
    String? location,
  }) {
    final updatedUser = state.user.copyWith(
      firstName: firstName,
      lastName: lastName,
      jobTitle: jobTitle,
      phoneNumber: phone,
      email: email,
      location: location,
    );
    emit(state.copyWith(user: updatedUser));
  }

  void updateAboutMe({String? summary, String? videoUrl}) {
    final updatedUser = state.user.copyWith(
      summary: summary,
      videoUrl: videoUrl,
    );
    emit(state.copyWith(user: updatedUser));
  }

  void updateUser(UserEntity newUser) {
    emit(state.copyWith(user: newUser));
  }

  // --- Work Experience Logic ---
  void addWorkExperience(WorkExperience experience) {
    final currentList = List<WorkExperience>.from(state.user.workExperiences);
    currentList.add(experience);
    currentList.sort((a, b) => b.startDate.compareTo(a.startDate));

    emit(
      state.copyWith(user: state.user.copyWith(workExperiences: currentList)),
    );
  }

  void removeWorkExperience(String id) {
    final currentList = List<WorkExperience>.from(state.user.workExperiences);
    currentList.removeWhere((element) => element.id == id);

    emit(
      state.copyWith(user: state.user.copyWith(workExperiences: currentList)),
    );
  }

  // --- Education Logic (New) ---
  void addEducation(Education education) {
    final currentList = List<Education>.from(state.user.educations);
    currentList.add(education);
    // Sort by most recent start date
    currentList.sort((a, b) => b.startDate.compareTo(a.startDate));

    emit(state.copyWith(user: state.user.copyWith(educations: currentList)));
  }

  void removeEducation(String id) {
    final currentList = List<Education>.from(state.user.educations);
    currentList.removeWhere((element) => element.id == id);

    emit(state.copyWith(user: state.user.copyWith(educations: currentList)));
  }
}
