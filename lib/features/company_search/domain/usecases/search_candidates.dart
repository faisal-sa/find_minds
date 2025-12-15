import 'package:graduation_project/features/shared/data/domain/entities/candidate_entity.dart';
import 'package:graduation_project/features/company_search/domain/repositories/company_search_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../core/error/failures.dart';

@lazySingleton
class SearchCandidatesUseCase {
  final SearchRepository _repository;

  SearchCandidatesUseCase(this._repository);

  Future<Result<List<CandidateEntity>, Failure>> call({
    String? location,
    List<String>? skills,
    List<String>? employmentTypes,
    bool? canRelocate,
    List<String>? languages,
    List<String>? workModes,
    String? jobTitle,
    List<String>? targetRoles,
  }) async {
    return await _repository.searchCandidates(
      location: location,
      skills: skills,
      employmentTypes: employmentTypes,
      canRelocate: canRelocate,
      languages: languages,
      workModes: workModes,
      jobTitle: jobTitle,
      targetRoles: targetRoles,
    );
  }
}
