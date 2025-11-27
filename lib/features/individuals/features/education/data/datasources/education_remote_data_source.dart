import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import '../../domain/entities/education.dart';
import '../models/education_model.dart';

abstract class EducationRemoteDataSource {
  Future<List<EducationModel>> getEducations();
  Future<void> addEducation(Education education);
  Future<void> updateEducation(Education education);
  Future<void> deleteEducation(String id);
}

@LazySingleton(as: EducationRemoteDataSource)
class EducationRemoteDataSourceImpl implements EducationRemoteDataSource {
  final SupabaseClient _supabase;

  EducationRemoteDataSourceImpl(this._supabase);

  String get _userId => _supabase.auth.currentUser!.id;

  @override
  Future<List<EducationModel>> getEducations() async {
    final response = await _supabase
        .from('educations')
        .select()
        .eq('user_id', _userId)
        .order('start_date', ascending: false);

    return (response as List)
        .map((e) => EducationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addEducation(Education education) async {
    // 1. Upload files if they exist
    String? gradCertUrl;
    String? academicRecUrl;

    if (education.graduationCertificate != null) {
      gradCertUrl = await _uploadFile(
        education.graduationCertificate!,
        'grad_cert_${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    if (education.academicRecord != null) {
      academicRecUrl = await _uploadFile(
        education.academicRecord!,
        'academic_rec_${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    // 2. Prepare Data
    final model = EducationModel(
      id: '', // DB generates this
      degreeType: education.degreeType,
      institutionName: education.institutionName,
      fieldOfStudy: education.fieldOfStudy,
      startDate: education.startDate,
      endDate: education.endDate,
      gpa: education.gpa,
      activities: education.activities,
      graduationCertificateUrl: gradCertUrl,
      academicRecordUrl: academicRecUrl,
    );

    // 3. Insert
    // We explicitly remove 'id' from toJson within the map here because it's a new record
    final data = model.toJson(userId: _userId);
    data.remove('id');

    await _supabase.from('educations').insert(data);
  }

  @override
  Future<void> updateEducation(Education education) async {
    // 1. Handle File Uploads (Only upload if a NEW file is selected)
    // If graduationCertificate (File) is null, keep the existing graduationCertificateUrl

    String? gradCertUrl = education.graduationCertificateUrl;
    String? academicRecUrl = education.academicRecordUrl;

    if (education.graduationCertificate != null) {
      gradCertUrl = await _uploadFile(
        education.graduationCertificate!,
        'grad_cert_${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    if (education.academicRecord != null) {
      academicRecUrl = await _uploadFile(
        education.academicRecord!,
        'academic_rec_${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    // 2. Prepare Data
    final model = EducationModel(
      id: education.id,
      degreeType: education.degreeType,
      institutionName: education.institutionName,
      fieldOfStudy: education.fieldOfStudy,
      startDate: education.startDate,
      endDate: education.endDate,
      gpa: education.gpa,
      activities: education.activities,
      graduationCertificateUrl: gradCertUrl,
      academicRecordUrl: academicRecUrl,
    );

    // 3. Update
    await _supabase
        .from('educations')
        .update(model.toJson(userId: _userId))
        .eq('id', education.id);
  }

  @override
  Future<void> deleteEducation(String id) async {
    await _supabase.from('educations').delete().eq('id', id);
    // Optional: Delete files from storage bucket here if strict cleanup is needed
  }

  /// Helper to upload file to 'education_files' bucket
  /// Returns the public URL
  Future<String> _uploadFile(File file, String fileNamePrefix) async {
    final fileExt = p.extension(file.path);
    final fileName = '$fileNamePrefix$fileExt';
    final filePath = '$_userId/$fileName'; // Structure: uid/filename

    await _supabase.storage
        .from('education_files')
        .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

    final url = _supabase.storage
        .from('education_files')
        .getPublicUrl(filePath);
    return url;
  }
}
