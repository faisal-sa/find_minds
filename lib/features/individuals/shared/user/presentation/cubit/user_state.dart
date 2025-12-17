import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
class UserState extends Equatable {
  final UserEntity user;
  final bool isResumeLoading;
  final String? resumeError;

  const UserState({
    this.user = const UserEntity(),
    this.isResumeLoading = false,
    this.resumeError,
  });

  
  double get profileCompletion {
    double score = 0.0;
    double maxScore = 100.0;

    // Basic Info (30 points)
    if (user.firstName.isNotEmpty && user.lastName.isNotEmpty) score += 10;
    if (user.email.isNotEmpty) score += 5;
    if (user.phoneNumber.isNotEmpty) score += 5;
    if (user.jobTitle.isNotEmpty) score += 5;
    if (user.location.isNotEmpty) score += 5;

    // Content (40 points)
    if (user.summary.isNotEmpty) score += 10;
    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) score += 5;
    if (user.videoUrl != null && user.videoUrl!.isNotEmpty) score += 5;
    if (user.skills.isNotEmpty) score += 10;
    if (user.languages.isNotEmpty) score += 10;

    // Experience & Education (30 points)
    if (user.workExperiences.isNotEmpty) score += 15;
    if (user.educations.isNotEmpty) score += 15;

    // Cap at 1.0 (100%)
    return (score / maxScore).clamp(0.0, 1.0);
  }

  UserState copyWith({
    UserEntity? user,
    bool? isResumeLoading,
    String? resumeError,
  }) {
    return UserState(
      user: user ?? this.user,
      isResumeLoading: isResumeLoading ?? this.isResumeLoading,
      resumeError: resumeError,
    );
  }

  @override
  List<Object?> get props => [user, isResumeLoading, resumeError];
}