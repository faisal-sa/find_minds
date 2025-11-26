import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'user_entity.dart';

class UserState extends Equatable {
  final UserEntity user;

  const UserState({this.user = const UserEntity()});

  // Calculate profile strength dynamically
  double get profileCompletion {
    int total = 0;
    int filled = 0;

    void check(String val) {
      total++;
      if (val.isNotEmpty) filled++;
    }

    check(user.firstName);
    check(user.lastName);
    check(user.jobTitle);
    check(user.location);
    check(user.email);
    check(user.phoneNumber);

    return total == 0 ? 0.0 : (filled / total);
  }

  UserState copyWith({UserEntity? user}) {
    return UserState(user: user ?? this.user);
  }

  @override
  List<Object> get props => [user];
}

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  // Call this to update the global app state
  void updateUser(UserEntity newUser) {
    emit(state.copyWith(user: newUser));
  }
}
