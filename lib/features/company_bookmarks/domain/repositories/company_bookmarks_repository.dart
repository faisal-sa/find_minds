import 'package:multiple_result/multiple_result.dart';
import '../../../../core/error/failures.dart';
import '../../../shared/data/domain/entities/candidate_entity.dart';

abstract class BookmarksRepository {
  Future<Result<List<CandidateEntity>, Failure>> getBookmarks(String companyId);

  Future<Result<void, Failure>> addBookmark(
    String companyId,
    String candidateId,
  );

  Future<Result<void, Failure>> removeBookmark(
    String companyId,
    String candidateId,
  );
}
