part of 'profile_cubit.dart';

@immutable
class ProfileState extends Equatable {
  final File? image;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String location;
  final int currentPage;
  final List<String> skills;
  final List<WorkExperience> experiences;

  const ProfileState({
    this.image,
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.location = '',
    this.currentPage = 0,
    this.skills = const [],
    this.experiences = const [],
  });

  ProfileState copyWith({
    File? image,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? location,
    int? currentPage,
    List<String>? skills,
    List<WorkExperience>? experiences,
  }) {
    return ProfileState(
      image: image ?? this.image,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      currentPage: currentPage ?? this.currentPage,
      skills: skills ?? this.skills,
      experiences: experiences ?? this.experiences,
    );
  }

  @override
  List<Object?> get props => [
    image,
    fullName,
    email,
    phoneNumber,
    location,
    currentPage,
    skills,
    experiences,
  ];
}
