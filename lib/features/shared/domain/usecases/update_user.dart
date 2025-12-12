import 'package:graduation_project/features/shared/domain/entities/user_entity.dart';
import 'package:graduation_project/features/shared/domain/repositories/user_repository.dart';

class UpdateUser {
  final UserRepository repository;
  UpdateUser(this.repository);
  
  Future<void> call(UserEntity user) async {
    await repository.updateRemoteProfile(user); // Send to Supabase
    await repository.cacheUser(user);           // Update Local Storage
  }
}