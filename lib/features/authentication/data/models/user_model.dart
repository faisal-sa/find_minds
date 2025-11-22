import 'package:graduation_project/features/authentication/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:dart_mappable/dart_mappable.dart';

part 'user_model.mapper.dart';

@MappableClass()
class UserModel with UserModelMappable {
  final String fullName;
  final String email;
  final bool isEmailVerified;
  final String? token;

  const UserModel({
    required this.fullName,
    required this.email,
    required this.isEmailVerified,
    this.token,
  });

  factory UserModel.fromSupabaseUser(supabase.User supabaseUser) {
    final metaData = supabaseUser.userMetadata ?? {};

    return UserModel(
      email: supabaseUser.email ?? '',
      fullName: metaData['full_name'] ?? 'No Name',
      isEmailVerified: false,
      token: "",
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      fullName: fullName,
      email: email,
      isEmailVerified: false,
      token: token,
    );
  }
}
