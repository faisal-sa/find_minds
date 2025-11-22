import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String fullName;
  final String email;
  final bool isEmailVerified;
  final String? token;

  const UserEntity({
    required this.fullName,
    required this.email,
    required this.isEmailVerified,
    required this.token,
  });

  UserEntity copyWith({
    String? fullName,
    String? email,
    String? avatarURL,
    bool? isEmailVerified,
    String? token,
  }) {
    return UserEntity(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [fullName, email, token, isEmailVerified];
}
