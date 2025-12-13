import 'package:graduation_project/features/shared/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class UserRemoteDataSource {
  final SupabaseClient supabase;

  UserRemoteDataSource(this.supabase);

  Future<UserEntity> fetchProfile(String userId) async {
    final response = await supabase.from('profiles').select('''
          *,
          educations (*),
          work_experiences (*),
          certifications (*)    
        ''').eq('id', userId).single();
    
    return UserEntity.fromJson(response);
  }

  Future<void> updateProfile(UserEntity user) async {
    final userId = supabase.auth.currentUser!.id;
    // Note: You might need to separate updates for related tables (educations, etc.)
    // based on how Supabase upserts work, but this follows your existing logic.
    await supabase.from('profiles').update(user.toJson()).eq('id', userId);
  }
}