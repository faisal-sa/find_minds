import 'package:fpdart/fpdart.dart';
import 'package:graduation_project/core/error/failures.dart';
import 'package:graduation_project/core/usecase/no_params.dart';
import 'package:graduation_project/core/usecase/usecase.dart';
import 'package:graduation_project/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SignoutUsecase implements Usecase<void, NoParams> {
  final AuthenticationRepository repository;
  const SignoutUsecase({required this.repository});

  @override
  TaskEither<Failure, void> call(NoParams params) {
    return repository.signOut();
  }
}
