import 'package:fpdart/fpdart.dart';
import 'package:graduation_project/features/candidate_details/domain/repositories/candidate_details_repository.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';

@injectable
class UnlockCandidateUseCase {
  final CandidateRepository _repository;

  UnlockCandidateUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String candidateId,
    required String companyId,
  }) {
    return _repository.unlockCandidateProfile(
      candidateId: candidateId,
      companyId: companyId,
    );
  }
}
