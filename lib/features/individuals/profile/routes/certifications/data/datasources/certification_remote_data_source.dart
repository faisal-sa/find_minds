import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/certification_model.dart';

abstract class CertificationRemoteDataSource {
  Future<List<CertificationModel>> getCertifications();
  Future<CertificationModel> addCertification(CertificationModel model);
  Future<void> updateCertification(CertificationModel model);
  Future<void> deleteCertification(String id);
  Future<String> uploadCredentialFile(File file, String userId);
}

@LazySingleton(as: CertificationRemoteDataSource)
class CertificationRemoteDataSourceImpl
    implements CertificationRemoteDataSource {
  final SupabaseClient _client;
  static const String _bucketName = 'certification_files';

  CertificationRemoteDataSourceImpl(this._client);

  @override
  Future<List<CertificationModel>> getCertifications() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception("User not authenticated");

    final response = await _client
        .from('certifications')
        .select()
        .eq('user_id', userId)
        .order('issue_date', ascending: false);

    return (response as List)
        .map((e) => CertificationModel.fromJson(e))
        .toList();
  }

  @override
  Future<CertificationModel> addCertification(CertificationModel model) async {
    // 1. Prepare data
    final data = model.toJson();
    if (model.id.isEmpty) {
      data.remove('id');
    }

    // 2. Insert into Database first to get the ID (or use the one provided)
    final response = await _client
        .from('certifications')
        .insert(data)
        .select()
        .single();

    CertificationModel insertedModel = CertificationModel.fromJson(response);

    // 3. --- FIX: Check for File and Upload ---
    if (model.credentialFile != null) {
      final userId = _client.auth.currentUser!.id;

      // Upload using the helper you already wrote
      final String publicUrl = await uploadCredentialFile(
        model.credentialFile!,
        userId,
      );

      // Update the database record with the new URL
      await _client
          .from('certifications')
          .update({'credential_url': publicUrl})
          .eq('id', insertedModel.id);

      // Return the model with the URL attached
      insertedModel = insertedModel.copyWith(credentialUrl: publicUrl);
    }
    // -----------------------------------------

    return insertedModel;
  }
  @override
  Future<void> updateCertification(CertificationModel model) async {
    // Remove {File? newFile}
    
    // 1. Fetch the CURRENT database record to get the OLD URL
    // We need this to know if we should delete an old file from storage.
    final oldRecord = await _client
        .from('certifications')
        .select('credential_url')
        .eq('id', model.id)
        .single();

    final String? oldUrl = oldRecord['credential_url'];
    
    // This will be the final URL we save to the DB
    String? finalUrl = model.credentialUrl;

    // CASE A: User selected a NEW file (Replacement or New Upload)
    if (model.credentialFile != null) {
      final userId = _client.auth.currentUser!.id;
      
      // Upload the new file
      finalUrl = await uploadCredentialFile(model.credentialFile!, userId);

      // If there was an old file, delete it to save space
      if (oldUrl != null && oldUrl.isNotEmpty) {
        final oldPath = _extractPathFromUrl(oldUrl);
        if (oldPath != null) {
          await _client.storage.from(_bucketName).remove([oldPath]);
        }
      }
    }
    // CASE B: User REMOVED the file (URL is null, File is null, but Old URL existed)
    else if (model.credentialUrl == null && oldUrl != null) {
      // The user clicked "Clear" in the UI, so we must delete the file from storage
      final oldPath = _extractPathFromUrl(oldUrl);
      if (oldPath != null) {
        await _client.storage.from(_bucketName).remove([oldPath]);
      }
      finalUrl = null;
    }
    // CASE C: No changes to file (File is null, URL matches old URL).
    // Do nothing regarding storage.

    // 2. Prepare Data for Update
    final data = model.toJson();
    data['credential_url'] = finalUrl; // Ensure the correct URL is set
    
    // Remove ID from the body (cannot update the primary key)
    data.remove('id');

    // 3. Update Database
    await _client
        .from('certifications')
        .update(data).eq('id', model.id);
  }
  @override
  Future<void> deleteCertification(String id) async {
    try {
      // 1. Fetch the record to get the URL
      final record = await _client
          .from('certifications')
          .select('credential_url')
          .eq('id', id)
          .single();

      final String? fileUrl = record['credential_url'];

      // 2. Delete from Storage FIRST
      if (fileUrl != null && fileUrl.isNotEmpty) {
        final path = _extractPathFromUrl(fileUrl);

        if (path != null) {
          // Attempt removal.
          // Note: If this fails due to RLS, it might not throw,
          // so ensure Step 1 (RLS) is applied correctly.
          final List<FileObject> result = await _client.storage
              .from(_bucketName)
              .remove([path]);

          // Optional debug: check if result is empty
          if (result.isEmpty) {
            print(
              'Warning: Storage file deletion returned empty. Check Path: $path or RLS policies.',
            );
          }
        }
      }

      // 3. Only after storage logic runs, delete the DB record
      await _client.from('certifications').delete().eq('id', id);
      
    } catch (e) {
      // If DB delete fails, the file is already gone (unfortunate but rare inconsistency).
      // If Storage delete throws, the DB row is preserved (good).
      throw Exception("Error deleting certification: $e");
    }
  }

  String? _extractPathFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      final bucketIndex = segments.indexOf(_bucketName);

      if (bucketIndex != -1 && bucketIndex < segments.length - 1) {
        // 1. Extract the path after the bucket name
        final rawPath = segments.sublist(bucketIndex + 1).join('/');

        // 2. Decode the URI component (Important!)
        // Supabase URLs might encode spaces as %20.
        // The storage.remove() function expects "file name.pdf", not "file%20name.pdf"
        return Uri.decodeComponent(rawPath);
      }
      return null;
    } catch (e) {
      print("Error parsing URL: $e");
      return null;
    }
  }

  @override
  Future<String> uploadCredentialFile(File file, String userId) async {
    final fileExt = file.path.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final filePath = '$userId/$fileName';

    await _client.storage.from(_bucketName).upload(filePath, file);

    final publicUrl = _client.storage
        .from(_bucketName)
        .getPublicUrl(filePath);

    return publicUrl;
  }

 
}
