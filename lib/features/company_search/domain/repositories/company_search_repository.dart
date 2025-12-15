import 'package:graduation_project/features/shared/data/domain/entities/candidate_entity.dart';
import 'package:multiple_result/multiple_result.dart';
import '../../../../core/error/failures.dart';

abstract class SearchRepository {
  Future<Result<List<CandidateEntity>, Failure>> searchCandidates({
    String? location,
    List<String>? skills,
    List<String>? employmentTypes,
    bool? canRelocate,
    List<String>? languages,
    List<String>? workModes,
    String? jobTitle,
    List<String>? targetRoles,
  });
}
