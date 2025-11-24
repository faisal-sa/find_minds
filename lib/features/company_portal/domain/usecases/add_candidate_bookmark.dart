import 'package:graduation_project/features/company_portal/domain/repositories/company_portal_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class AddCandidateBookmark {
  final CompanyRepository repo;
  AddCandidateBookmark(this.repo);

  Future<Result<void, String>> call(String companyId, String candidateId) {
    return repo.addCandidateBookmark(companyId, candidateId);
  }
}
