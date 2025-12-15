// lib/features/candidate_details/data/data_sources/candidate_details_data_source.dart

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/candidate_profile_model.dart';

abstract class CandidateRemoteDataSource {
  Future<CandidateProfileModel> getCandidateProfile(
    String candidateId,
    String companyId,
  );
  Future<void> toggleBookmark(String candidateId, String companyId);
  Future<void> unlockCompanyAccess(String companyId);
}

@LazySingleton(as: CandidateRemoteDataSource)
class CandidateRemoteDataSourceImpl implements CandidateRemoteDataSource {
  final SupabaseClient _supabase;

  CandidateRemoteDataSourceImpl(this._supabase);

  @override
  Future<CandidateProfileModel> getCandidateProfile(
    String candidateId,
    String companyId,
  ) async {
    try {
      final companyData = await _supabase
          .from('companies')
          .select('is_premium')
          .eq('id', companyId)
          .single();
      final bool isPremium = companyData['is_premium'] ?? false;

      final bookmarkRes = await _supabase
          .from('company_bookmarks') // اسم جدول المفضلة لديك
          .select('id')
          .eq('company_id', companyId)
          .eq('candidate_id', candidateId)
          .maybeSingle();
      final bool isBookmarked = bookmarkRes != null;

      // 3. جلب بيانات المرشح من جدول 'profiles'
      final response = await _supabase
          .from('profiles')
          .select('''
            *,
            work_experiences(*),
            educations(*),
            certifications(*)
          ''')
          .eq('id', candidateId)
          .single();

      // 4. إنشاء الموديل مع تمرير جميع الحالات
      return CandidateProfileModel.fromSupabase(
        response,
        isPremium, // Unlocked Status
        isBookmarked, // Bookmark Status
      );
    } catch (e) {
      throw Exception("Failed to load profile: $e");
    }
  }

  @override
  Future<void> toggleBookmark(String candidateId, String companyId) async {
    final exists = await _supabase
        .from('company_bookmarks')
        .select('id')
        .eq('company_id', companyId)
        .eq('candidate_id', candidateId)
        .maybeSingle();

    if (exists != null) {
      // حذف من المفضلة
      await _supabase
          .from('company_bookmarks')
          .delete()
          .eq('company_id', companyId)
          .eq('candidate_id', candidateId);
    } else {
      // إضافة للمفضلة
      await _supabase.from('company_bookmarks').insert({
        'company_id': companyId,
        'candidate_id': candidateId,
      });
    }
  }

  @override
  Future<void> unlockCompanyAccess(String companyId) async {
    await _supabase
        .from('companies')
        .update({'is_premium': true})
        .eq('id', companyId);
  }
}
