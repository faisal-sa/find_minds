import 'package:equatable/equatable.dart';

import 'package:fpdart/fpdart.dart';
import 'package:graduation_project/core/error/failures.dart';
import 'package:graduation_project/core/usecase/usecase.dart';
import 'package:graduation_project/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SignupUsecase implements Usecase<void, SignUpParams> {
  final AuthenticationRepository repository;
  SignupUsecase({required this.repository});

  @override
  TaskEither<Failure, void> call(SignUpParams params) {
    return repository.signUp(params.email, params.password);
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String name;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}
