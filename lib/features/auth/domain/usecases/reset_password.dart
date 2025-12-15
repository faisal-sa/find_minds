import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecasesAbstract/usecase.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordParams {
  final String email;

  ResetPasswordParams({required this.email});
}

@injectable
class ResetPassword implements UseCase<void, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPassword(this.repository);

  @override
  Future<Result<void, Failure>> call(ResetPasswordParams params) {
    return repository.resetPassword(email: params.email);
  }
}
