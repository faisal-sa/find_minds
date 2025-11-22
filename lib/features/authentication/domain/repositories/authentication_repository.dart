import 'package:fpdart/fpdart.dart';
import 'package:graduation_project/core/error/failures.dart';
import 'package:graduation_project/features/authentication/domain/entities/user_entity.dart';

abstract class AuthenticationRepository {
  TaskEither<Failure, UserEntity> getCurrentUser();
  TaskEither<Failure, UserEntity> login(String email, String password);
  TaskEither<Failure, void> signOut();
  TaskEither<Failure, UserEntity> signUp(String email, String password);
}
