import 'dart:typed_data';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> getLastLocalUser();
  Future<void> cacheUser(UserEntity user);
  Future<UserEntity> fetchRemoteProfile(String userId);
  Future<void> updateRemoteProfile(UserEntity user);
  Future<UserEntity> extractResumeData(Uint8List fileBytes);
}