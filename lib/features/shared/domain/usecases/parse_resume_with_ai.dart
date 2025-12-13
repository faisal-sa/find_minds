import 'dart:typed_data';

import 'package:graduation_project/features/shared/domain/entities/user_entity.dart';
import 'package:graduation_project/features/shared/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ParseResumeWithAI {
  final UserRepository repository;
  ParseResumeWithAI(this.repository);
  Future<UserEntity> call(Uint8List bytes) => repository.extractResumeData(bytes);
}