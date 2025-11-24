part of 'company_bloc.dart';

@immutable
abstract class CompanyState {}

class CompanyInitial extends CompanyState {}

class CompanyLoading extends CompanyState {}

class CompanyLoaded extends CompanyState {
  final CompanyEntity company;
  CompanyLoaded(this.company);
}

class CandidateResults extends CompanyState {
  final List<Map<String, dynamic>> candidates;
  CandidateResults(this.candidates);
}

class CompanyError extends CompanyState {
  final String message;
  CompanyError(this.message);
}

class BookmarkAdded extends CompanyState {}
