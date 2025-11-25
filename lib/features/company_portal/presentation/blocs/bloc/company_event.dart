part of 'company_bloc.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();
  @override
  List<Object?> get props => [];
}

class GetCompanyProfileEvent extends CompanyEvent {
  final String userId;
  const GetCompanyProfileEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateCompanyProfileEvent extends CompanyEvent {
  final CompanyEntity company;
  const UpdateCompanyProfileEvent(this.company);

  @override
  List<Object?> get props => [company];
}

// ---------- SEARCH ----------
class SearchCandidatesEvent extends CompanyEvent {
  final String? city;
  final String? skill;
  final String? experience;
  const SearchCandidatesEvent({this.city, this.skill, this.experience});

  @override
  List<Object?> get props => [city, skill, experience];
}

// ---------- BOOKMARK (QR) ----------
class AddCandidateBookmarkEvent extends CompanyEvent {
  final String candidateId;
  const AddCandidateBookmarkEvent(this.candidateId);

  @override
  List<Object?> get props => [candidateId];
}
