import 'package:graduation_project/features/company_bookmarks/domain/repositories/company_bookmarks_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../core/error/failures.dart';

@lazySingleton
class RemoveBookmarkUseCase {
  final BookmarksRepository _repository;

  RemoveBookmarkUseCase(this._repository);

  Future<Result<void, Failure>> call(
    String companyId,
    String candidateId,
  ) async {
    return await _repository.removeBookmark(companyId, candidateId);
  }
}
