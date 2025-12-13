import 'package:graduation_project/features/shared/domain/entities/user_entity.dart';
import 'package:graduation_project/features/shared/domain/repositories/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SyncUserToRemote {
  final UserRepository repository;
  SyncUserToRemote(this.repository);
  
  Future<void> call(UserEntity user) async {
    await repository.updateRemoteProfile(user);
    await repository.cacheUser(user);
  }
}