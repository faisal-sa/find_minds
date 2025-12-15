import 'package:graduation_project/features/company_bookmarks/domain/repositories/company_bookmarks_repository.dart';
import 'package:graduation_project/features/shared/data/domain/entities/candidate_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../core/error/failures.dart';

@lazySingleton
class GetBookmarksUseCase {
  final BookmarksRepository _repository;

  GetBookmarksUseCase(this._repository);

  Future<Result<List<CandidateEntity>, Failure>> call(String companyId) async {
    return await _repository.getBookmarks(companyId);
  }
}
