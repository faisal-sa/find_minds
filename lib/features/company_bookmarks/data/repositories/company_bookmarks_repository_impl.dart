import 'package:graduation_project/features/company_bookmarks/data/data_sources/company_bookmarks_data_source.dart';
import 'package:graduation_project/features/company_bookmarks/domain/repositories/company_bookmarks_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/error/failures.dart';
import '../../../shared/data/models/candidate_model.dart';
import '../../../shared/data/domain/entities/candidate_entity.dart';

@Injectable(as: BookmarksRepository)
class BookmarksRepositoryImpl implements BookmarksRepository {
  final BookmarksRemoteDataSource _remoteDataSource;

  BookmarksRepositoryImpl(this._remoteDataSource);

  Failure _mapExceptionToFailure(Exception e) {
    if (e.toString().contains('SupabaseException')) {
      return ServerFailure(e.toString().replaceAll('SupabaseException: ', ''));
    }
    return UnknownFailure(e.toString());
  }

  @override
  Future<Result<List<CandidateEntity>, Failure>> getBookmarks(
    String companyId,
  ) async {
    try {
      final resultList = await _remoteDataSource.getBookmarks(companyId);

      final entities = resultList.map<CandidateEntity>((data) {
        final CandidateModel model = CandidateModelMapper.ensureInitialized()
            .decodeMap(data);
        return model.toEntity();
      }).toList();

      return Success(entities);
    } on Exception catch (e) {
      return Error(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> addBookmark(
    String companyId,
    String candidateId,
  ) async {
    try {
      await _remoteDataSource.addBookmark(companyId, candidateId);
      return const Success(null);
    } on Exception catch (e) {
      return Error(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void, Failure>> removeBookmark(
    String companyId,
    String candidateId,
  ) async {
    try {
      await _remoteDataSource.removeBookmark(companyId, candidateId);
      return const Success(null);
    } on Exception catch (e) {
      return Error(_mapExceptionToFailure(e));
    }
  }
}
