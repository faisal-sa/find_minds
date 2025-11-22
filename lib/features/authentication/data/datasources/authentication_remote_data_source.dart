
import 'package:graduation_project/core/error/failures.dart';
import 'package:graduation_project/features/authentication/data/models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthenticationRemoteDataSource {
  Future<UserModel> getCurrentUser();
  Future<UserModel> login(String email, String password);
  Future<void> signOut();
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  });
}

@LazySingleton(as: AuthenticationRemoteDataSource)
class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthenticationRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> getCurrentUser() async {
    final supabaseUser = supabaseClient.auth.currentUser;
    if (supabaseUser == null) {
      throw ServerFailure('Not authenticated');
    }
    return UserModel.fromSupabaseUser(supabaseUser);
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw ServerFailure('Login failed: User not found.');
      }
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,

        data: {'full_name': name},
      );
      if (response.user == null) {
        throw ServerFailure('Sign up failed: User could not be created.');
      }
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
