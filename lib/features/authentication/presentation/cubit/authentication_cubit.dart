// ignore_for_file: unused_field

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/usecase/no_params.dart';
import 'package:graduation_project/features/authentication/domain/entities/user_entity.dart';
import 'package:graduation_project/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:graduation_project/features/authentication/domain/usecases/login_usecase.dart';
import 'package:graduation_project/features/authentication/domain/usecases/signout_usecase.dart';
import 'package:graduation_project/features/authentication/domain/usecases/signup_usecase.dart';
import 'package:injectable/injectable.dart';
part 'authentication_state.dart';

@lazySingleton
class AuthenticationCubit extends Cubit<AuthenticationState> {
  final GetCurrentUserUsecase _getCurrentUser;
  final LoginUsecase _login;
  final SignoutUsecase _signout;
  final SignupUsecase _signup;

  AuthenticationCubit({
    required GetCurrentUserUsecase getCurrentUserUsecase,
    required LoginUsecase loginUsecase,
    required SignoutUsecase signoutUsecase,
    required SignupUsecase signupUsecase,
  }) : _getCurrentUser = getCurrentUserUsecase,
       _login = loginUsecase,
       _signout = signoutUsecase,
       _signup = signupUsecase,
       super(AuthenticationInitial());

  Future<void> login(LoginParams params) async {
    emit(AuthenticationLoading());

    await _login(params).run().then(
      (result) => result.fold(
        (failure) => emit(AuthenticationError(message: failure.toString())),
        (user) => emit(AuthenticationSuccess(user: user)),
      ),
    );
  }

  Future<void> signup(SignUpParams params) async {
    emit(AuthenticationLoading());

    await _signup(params).run().then(
      (result) => result.fold(
        (failure) => emit(AuthenticationError(message: failure.message)),
        (_) => emit(
          AuthenticationSuccess(
            user: UserEntity(
              fullName: "fullName",
              email: "email",
              isEmailVerified: false,
              token: '',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout(NoParams params) async {
    await _signout(params).run().then(
      (result) => result.fold(
        (failure) => emit(AuthenticationError(message: failure.message)),
        (_) => emit(AuthenticationInitial()),
      ),
    );
  }
}

extension AuthActions on BuildContext {
  Future<void> login(LoginParams params) {
    return read<AuthenticationCubit>().login(params);
  }

  Future<void> logout(NoParams params) {
    return read<AuthenticationCubit>().logout(params);
  }

  Future<void> signup(SignUpParams params) {
    return read<AuthenticationCubit>().signup(params);
  }
}
