import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecasesAbstract/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class VerifyPasswordResetOTPParams {
  final String email;
  final String token;

  VerifyPasswordResetOTPParams({required this.email, required this.token});
}

@injectable
class VerifyPasswordResetOTP
    implements UseCase<User, VerifyPasswordResetOTPParams> {
  final AuthRepository repository;

  VerifyPasswordResetOTP(this.repository);

  @override
  Future<Result<User, Failure>> call(VerifyPasswordResetOTPParams params) {
    return repository.verifyPasswordResetOTP(
      email: params.email,
      token: params.token,
    );
  }
}
