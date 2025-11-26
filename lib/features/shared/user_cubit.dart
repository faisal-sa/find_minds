// user_cubit.dart
class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  // Call this when the app starts or after login
  void setInitialUserData(UserEntity user) {
    emit(state.copyWith(user: user));
  }

  // Call this from other Cubits/Pages when data changes
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
          // Fallback if creating new
          firstName: firstName ?? '',
          lastName: lastName ?? '',
          jobTitle: jobTitle ?? '',
          phoneNumber: phone ?? '',
          email: email ?? '',
          location: location ?? '',
        );

    emit(state.copyWith(user: updatedUser));
  }
}
