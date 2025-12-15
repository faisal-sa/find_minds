import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecasesAbstract/usecase.dart';
import '../repositories/auth_repository.dart';

class SendPasswordResetOTPParams {
  final String email;

  SendPasswordResetOTPParams({required this.email});
}

@injectable
class SendPasswordResetOTP
    implements UseCase<void, SendPasswordResetOTPParams> {
  final AuthRepository repository;

  SendPasswordResetOTP(this.repository);

  @override
  Future<Result<void, Failure>> call(SendPasswordResetOTPParams params) {
    return repository.sendPasswordResetOTP(email: params.email);
  }
}
