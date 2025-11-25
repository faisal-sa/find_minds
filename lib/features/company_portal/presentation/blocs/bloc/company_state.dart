part of 'company_bloc.dart';

abstract class CompanyState extends Equatable {
  const CompanyState();
  @override
  List<Object?> get props => [];
}

class CompanyInitial extends CompanyState {
  const CompanyInitial();
}

class CompanyLoading extends CompanyState {
  const CompanyLoading();
}

class CompanyLoaded extends CompanyState {
  final CompanyEntity company;
  const CompanyLoaded(this.company);

  @override
  List<Object?> get props => [company];
}

class CandidateResults extends CompanyState {
  final List<Map<String, dynamic>> candidates;
  const CandidateResults(this.candidates);

  @override
  List<Object?> get props => [candidates];
}

class BookmarkAddedSuccessfully extends CompanyState {
  const BookmarkAddedSuccessfully();
}

class CompanyError extends CompanyState {
  final String message;
  const CompanyError(this.message);

  @override
  List<Object?> get props => [message];
}
