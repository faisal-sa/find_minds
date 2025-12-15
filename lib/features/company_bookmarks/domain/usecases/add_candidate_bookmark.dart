// lib/features/company_portal/domain/usecases/add_candidate_bookmark.dart

import 'package:graduation_project/features/company_bookmarks/domain/repositories/company_bookmarks_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../core/error/failures.dart';

@injectable
class AddCandidateBookmark {
  final BookmarksRepository _repository;

  AddCandidateBookmark(this._repository);

  Future<Result<void, Failure>> call(String companyId, String candidateId) {
    return _repository.addBookmark(companyId, candidateId);
  }
}
