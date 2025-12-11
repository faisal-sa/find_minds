import 'package:fpdart/fpdart.dart';
import 'package:graduation_project/core/error/failures.dart';
import 'package:graduation_project/features/individuals/features/skills_languages/domain/entities/skills_and_languages_entity.dart';

abstract class SkillsLanguagesRepository {
  Future<Either<Failure, Unit>> updateSkills(List<String> skills);
  Future<Either<Failure, Unit>> updateLanguages(List<String> languages);
  Future<Either<Failure, SkillsAndLanguages>> getData();
}
