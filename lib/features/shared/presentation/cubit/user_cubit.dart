import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/individuals/features/certifications/domain/entities/certification.dart';
import 'package:graduation_project/features/individuals/features/education/domain/entities/education.dart';
import 'package:graduation_project/features/individuals/features/job_preferences/domain/entities/job_preferences_entity.dart';
import 'package:graduation_project/features/individuals/features/work_experience/domain/entities/work_experience.dart';
import 'package:graduation_project/features/shared/domain/entities/user_entity.dart';
import 'package:graduation_project/features/shared/domain/usecases/cache_user.dart';
import 'package:graduation_project/features/shared/domain/usecases/fetch_user_profile.dart';
import 'package:graduation_project/features/shared/domain/usecases/get_cached_user.dart';
import 'package:graduation_project/features/shared/domain/usecases/parse_resume_with_ai.dart';
import 'package:graduation_project/features/shared/presentation/cubit/user_state.dart';
import 'package:injectable/injectable.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class UserCubit extends Cubit<UserState> {
  // Dependencies
  final GetCachedUser _getCachedUser;
  final CacheUser _cacheUser;
  final FetchUserProfile _fetchUserProfile;
  final ParseResumeWithAI _parseResumeWithAI;
  
  // Optional: If you need current user ID, you can inject SupabaseClient 
  // just to get the ID, or pass the ID into the methods.
  final SupabaseClient _supabaseClient; 
  bool _isLoadingFromStorage = false;


  UserCubit(
    this._getCachedUser,
    this._cacheUser,
    this._fetchUserProfile,
    this._parseResumeWithAI,
    this._supabaseClient,
  ) : super(const UserState()) {
    _loadUserFromStorage();
  }

  //=========================================================== LOCAL STORAGE LOGIC ===========================================================
  
 Future<void> _loadUserFromStorage() async {
    print("loading user from storage");
    _isLoadingFromStorage = true; // Raise flag

    try {
      final user = await _getCachedUser();
      if (user != null) {
        emit(state.copyWith(user: user));
      }
    } catch (e) {
      print("Error loading local user: $e");
    } finally {
      _isLoadingFromStorage = false; // Lower flag after emit is done
    }
  }

  @override
  void onChange(Change<UserState> change) {
    super.onChange(change);

    // FIX 2: Don't save if the change was caused by loading from storage
    if (_isLoadingFromStorage) {
      print("UserCubit: Loaded from storage (Skipping auto-save)");
      return;
    }

    if (change.nextState.user != change.currentState.user) {
      print("UserCubit: User entity changed, saving to storage...");
      _cacheUser(change.nextState.user);
    }
  }


  void setInitialUserData(UserEntity user) {
    emit(state.copyWith(user: user));
  }

  // =========================================================== CHANGING STATE LOGIC ===========================================================
  
  // These methods manipulate the state in memory. 
  // Clean Architecture doesn't forbid logic in Cubits; it forbids data access logic.
  
  void updateLocalAvatar(String url) {
    emit(state.copyWith(user: state.user.copyWith(avatarUrl: url)));
  }

  void updateSkillsAndLanguages(List<String> skills, List<String> languages) {
    emit(state.copyWith(
      user: state.user.copyWith(skills: skills, languages: languages),
    ));
  }

  void updateJobPreferences(JobPreferencesEntity newPreferences) {
    emit(state.copyWith(
      user: state.user.copyWith(jobPreferences: newPreferences),
    ));
  }

  void updateCertificationsList(List<Certification> certifications) {
    emit(state.copyWith(user: state.user.copyWith(certifications: certifications)));
  }

  void updateBasicInfo({
    String? firstName,
    String? lastName,
    String? jobTitle,
    String? phone,
    String? email,
    String? location,
  }) {
    final updatedUser = state.user.copyWith(
      firstName: firstName ?? state.user.firstName,
      lastName: lastName ?? state.user.lastName,
      jobTitle: jobTitle ?? state.user.jobTitle,
      phoneNumber: phone ?? state.user.phoneNumber,
      email: email ?? state.user.email,
      location: location ?? state.user.location,
    );
    emit(state.copyWith(user: updatedUser));
  }

  void updateAboutMe({String? summary, String? videoUrl}) {
    final u = state.user;
    // Explicit construction to handle nullable videoUrl correctly
    final updatedUser = u.copyWith(summary: summary ?? u.summary).copyWith(
      // Note: Freezed copyWith usually ignores nulls. 
      // To explicitly set null in Freezed, logic depends on version.
      // If your manual manual construction logic was simpler, stick to that:
    );

    // Reverting to your manual logic for safety regarding null videoUrl:
    final explicitUser = UserEntity(
      firstName: u.firstName,
      lastName: u.lastName,
      jobTitle: u.jobTitle,
      phoneNumber: u.phoneNumber,
      email: u.email,
      location: u.location,
      avatarUrl: u.avatarUrl,
      workExperiences: u.workExperiences,
      educations: u.educations,
      certifications: u.certifications,
      skills: u.skills,
      languages: u.languages,
      jobPreferences: u.jobPreferences,
      summary: summary ?? u.summary,
      videoUrl: videoUrl, // Allows null
    );

    emit(state.copyWith(user: explicitUser));
  }

  void deleteUserVideo() {
    print("UserCubit: Deleting user video...");
    final u = state.user;
    
    // Explicitly reconstruct to force null
    final updatedUser = UserEntity(
      firstName: u.firstName,
      lastName: u.lastName,
      jobTitle: u.jobTitle,
      phoneNumber: u.phoneNumber,
      email: u.email,
      location: u.location,
      summary: u.summary,
      avatarUrl: u.avatarUrl,
      workExperiences: u.workExperiences,
      educations: u.educations,
      certifications: u.certifications,
      skills: u.skills,
      languages: u.languages,
      jobPreferences: u.jobPreferences,
      videoUrl: null, // Force NULL
    );

    emit(state.copyWith(user: updatedUser));
    // _cacheUser is called automatically by onChange
  }

  void updateUser(UserEntity newUser) {
    emit(state.copyWith(user: newUser));
  }

  // ... [List Sorting Logic remains the same] ...
  
  void updateWorkExperiencesList(List<WorkExperience> experiences) {
    final sortedList = List<WorkExperience>.from(experiences)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
    emit(state.copyWith(user: state.user.copyWith(workExperiences: sortedList)));
  }

  void updateEducationsList(List<Education> educations) {
    final sortedList = List<Education>.from(educations)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
    emit(state.copyWith(user: state.user.copyWith(educations: sortedList)));
  }

  void addWorkExperience(WorkExperience experience) {
    final currentList = List<WorkExperience>.from(state.user.workExperiences);
    currentList.add(experience);
    currentList.sort((a, b) => b.startDate.compareTo(a.startDate));
    emit(state.copyWith(user: state.user.copyWith(workExperiences: currentList)));
  }

  void removeWorkExperience(String id) {
    final currentList = List<WorkExperience>.from(state.user.workExperiences);
    currentList.removeWhere((element) => element.id == id);
    emit(state.copyWith(user: state.user.copyWith(workExperiences: currentList)));
  }

  void addEducation(Education education) {
    final currentList = List<Education>.from(state.user.educations);
    currentList.add(education);
    currentList.sort((a, b) => b.startDate.compareTo(a.startDate));
    emit(state.copyWith(user: state.user.copyWith(educations: currentList)));
  }

  void removeEducation(String id) {
    final currentList = List<Education>.from(state.user.educations);
    currentList.removeWhere((element) => element.id == id);
    emit(state.copyWith(user: state.user.copyWith(educations: currentList)));
  }

  // =========================================================== SUPABASE FETCHING LOGIC ===========================================================
  
  Future<void> fetchUserProfile() async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) return;

      // Delegate to UseCase
      final fetchedUser = await _fetchUserProfile(userId);

      emit(state.copyWith(user: fetchedUser));
      // Local cache update is handled inside FetchUserProfile -> Repository, 
      // OR explicitly by onChange when we emit here.
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  //=========================================================== CV ANALYSIS LOGIC ============================================================
  
  Future<void> uploadAndExtractResume() async {
    try {
      emit(state.copyWith(isResumeLoading: true, resumeError: null));

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null) {
        emit(state.copyWith(isResumeLoading: false));
        return;
      }

      final platformFile = result.files.single;
      Uint8List? fileBytes;

      if (platformFile.bytes != null) {
        fileBytes = platformFile.bytes;
      } else if (platformFile.path != null && !kIsWeb) {
        final file = File(platformFile.path!);
        fileBytes = await file.readAsBytes();
      }

      if (fileBytes == null) {
        emit(state.copyWith(isResumeLoading: false));
        return;
      }

      // Delegate pure AI extraction logic to UseCase
      final extractedUser = await _parseResumeWithAI(fileBytes);

      // Merge Logic (Logic stays in Cubit as it determines how to apply the data)
      final updatedUser = state.user.copyWith(
        firstName: extractedUser.firstName.isNotEmpty ? extractedUser.firstName : state.user.firstName,
        lastName: extractedUser.lastName.isNotEmpty ? extractedUser.lastName : state.user.lastName,
        email: extractedUser.email.isNotEmpty ? extractedUser.email : state.user.email,
        phoneNumber: extractedUser.phoneNumber.isNotEmpty ? extractedUser.phoneNumber : state.user.phoneNumber,
        summary: extractedUser.summary.isNotEmpty ? extractedUser.summary : state.user.summary,
      );

      emit(state.copyWith(user: updatedUser, isResumeLoading: false));
      
    } catch (e) {
      emit(state.copyWith(
        isResumeLoading: false,
        resumeError: 'Failed to process resume: $e',
      ));
    }
  }
}