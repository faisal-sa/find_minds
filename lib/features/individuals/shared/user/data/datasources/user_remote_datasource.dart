import 'package:graduation_project/features/individuals/shared/user/domain/entities/user_entity.dart';
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
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final profileData = user.toJson();
    profileData.remove('work_experiences');
    profileData.remove('educations');
    profileData.remove('certifications'); 
    profileData.remove('job_preferences'); 
    profileData['id'] = userId;
    profileData['updated_at'] = DateTime.now().toIso8601String();

    await supabase.from('profiles').upsert(profileData);

    List<Map<String, dynamic>> prepareItems(List<dynamic> items) {
      return items.map((e) {
        final json = e.toJson();
        json['user_id'] = userId;

        return json;
      }).toList().cast<Map<String, dynamic>>();
    }

    if (user.workExperiences.isNotEmpty) {
      await supabase.from('work_experiences').upsert(prepareItems(user.workExperiences));
    }

    if (user.educations.isNotEmpty) {
      await supabase.from('educations').upsert(prepareItems(user.educations));
    }
    
    if (user.certifications.isNotEmpty) {
      await supabase.from('certifications').upsert(prepareItems(user.certifications));
    }
  }
}