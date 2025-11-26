// user_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/shared/user_entity.dart';
import 'package:graduation_project/features/shared/user_state.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  void setInitialUserData(UserEntity user) {
    emit(state.copyWith(user: user));
  }

  void updateUserProfile({
    String? firstName,
    String? lastName,
    String? jobTitle,
    String? phone,
    String? email,
    String? location,
  }) {
    final updatedUser =
        state.user?.copyWith(
          firstName: firstName,
          lastName: lastName,
          jobTitle: jobTitle,
          phoneNumber: phone,
          email: email,
          location: location,
        ) ??
        UserEntity(
          firstName: firstName ?? '',
          lastName: lastName ?? '',
          jobTitle: jobTitle ?? '',
          phoneNumber: phone ?? '',
          email: email ?? '',
          location: location ?? '',
        );

    emit(state.copyWith(user: updatedUser));
  }

  void updateUser(UserEntity newUser) {
    emit(state.copyWith(user: newUser));
  }
}
