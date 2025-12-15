import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecasesAbstract/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdatePasswordParams {
  final String newPassword;

  UpdatePasswordParams({required this.newPassword});
}

@injectable
class UpdatePassword implements UseCase<User, UpdatePasswordParams> {
  final AuthRepository repository;

  UpdatePassword(this.repository);

  @override
  Future<Result<User, Failure>> call(UpdatePasswordParams params) {
    return repository.updatePassword(newPassword: params.newPassword);
  }
}
