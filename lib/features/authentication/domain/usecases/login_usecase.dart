import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graduation_project/core/error/failures.dart';
import 'package:graduation_project/core/usecase/usecase.dart';
import 'package:graduation_project/features/authentication/domain/entities/user_entity.dart';
import 'package:graduation_project/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LoginUsecase implements Usecase<UserEntity, LoginParams> {
  final AuthenticationRepository repository;
  LoginUsecase({required this.repository});

  @override
  TaskEither<Failure, UserEntity> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
