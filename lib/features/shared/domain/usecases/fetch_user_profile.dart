import 'package:graduation_project/features/shared/domain/entities/user_entity.dart';
import 'package:graduation_project/features/shared/domain/repositories/user_repository.dart';

class FetchUserProfile {
  final UserRepository repository;
  FetchUserProfile(this.repository);
  Future<UserEntity> call(String userId) => repository.fetchRemoteProfile(userId);
}