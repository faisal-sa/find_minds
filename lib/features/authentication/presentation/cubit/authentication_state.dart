part of 'authentication_cubit.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String message;

  const AuthenticationError({required this.message});
  @override
  List<Object> get props => [message];
}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final UserEntity user;

  const AuthenticationSuccess({required this.user});
  @override
  List<Object> get props => [user];
}
