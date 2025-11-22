import 'package:fpdart/fpdart.dart';
import 'package:graduation_project/core/error/failures.dart';
import 'package:graduation_project/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:graduation_project/features/authentication/domain/entities/user_entity.dart';
import 'package:graduation_project/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource remoteDataSource;

  AuthenticationRepositoryImpl({required this.remoteDataSource});

  @override
  TaskEither<Failure, UserEntity> getCurrentUser() {
    return _tryCatch(
      () => remoteDataSource.getCurrentUser(),
    ).map((userModel) => userModel.toEntity());
  }

  @override
  TaskEither<Failure, UserEntity> login(String email, String password) {
    return _tryCatch(
      () => remoteDataSource.login(email, password),
    ).map((userModel) => userModel.toEntity());
  }

  @override
  TaskEither<Failure, void> signOut() {
    return _tryCatch(() => remoteDataSource.signOut());
  }

  @override
  TaskEither<Failure, UserEntity> signUp(String email, String password) {
    return _tryCatch(
      () => remoteDataSource.signUp(email: email, password: password, name: ''),
    ).map((userModel) => userModel.toEntity());
  }

  TaskEither<Failure, T> _tryCatch<T>(Future<T> Function() f) {
    return TaskEither.tryCatch(f, (error, stackTrace) {
      if (error is AuthException) {
        return ServerFailure(error.message);
      }
      if (error is PostgrestException) {
        return ServerFailure(error.message);
      }
      return ServerFailure("An unexpected error occurred: ${error.toString()}");
    });
  }
}
