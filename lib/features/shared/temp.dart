import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class UserProfileTemp extends Equatable {
  final String? name;

  const UserProfileTemp({this.name});

  bool get isComplete => name != null && name!.isNotEmpty;

  int get progress => isComplete ? 35 : 5;

  @override
  List<Object?> get props => [name];
}

class UserCubitTemp extends Cubit<UserProfileTemp> {
  UserCubitTemp() : super(const UserProfileTemp(name: null));

  void uploadResume() {
    emit(const UserProfileTemp(name: "Alex Johnson"));
  }

  void resetProfile() {
    emit(const UserProfileTemp(name: null));
  }
}
