import 'package:graduation_project/features/shared/domain/entities/user_entity.dart';
import 'package:graduation_project/features/shared/domain/repositories/user_repository.dart';

class GetCachedUser {
  final UserRepository repository;
  GetCachedUser(this.repository);
  Future<UserEntity?> call() => repository.getLastLocalUser();
}