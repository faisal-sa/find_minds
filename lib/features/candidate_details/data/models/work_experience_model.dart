// data/models/work_experience_model.dart
import 'package:dart_mappable/dart_mappable.dart';
import '../../domain/entities/work_experience_entity.dart';

part 'work_experience_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class WorkExperienceModel extends WorkExperienceEntity
    with WorkExperienceModelMappable {
  const WorkExperienceModel({
    required super.id,
    required super.jobTitle,
    required super.companyName,
    required super.location,
    required super.startDate,
    super.endDate,
    @MappableField(key: 'is_currently_working')
    required super.isCurrentlyWorking,
    @MappableField(key: 'responsibilities')
    super.description, // Mapping custom keys
  });
}
