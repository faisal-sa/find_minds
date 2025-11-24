import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/company_portal/domain/entities/company_entity.dart';
import 'package:graduation_project/features/company_portal/domain/usecases/add_candidate_bookmark.dart';
import 'package:graduation_project/features/company_portal/domain/usecases/get_company_profile.dart';
import 'package:graduation_project/features/company_portal/domain/usecases/search_candidates.dart';
import 'package:graduation_project/features/company_portal/domain/usecases/update_company_profile.dart';
import 'package:injectable/injectable.dart';

part 'company_event.dart';
part 'company_state.dart';

@injectable
class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final GetCompanyProfile _getCompanyProfile;
  final UpdateCompanyProfile _updateCompanyProfile;
  final SearchCandidates _searchCandidates;
  final AddCandidateBookmark _addCandidateBookmark;

  CompanyBloc(
    this._getCompanyProfile,
    this._updateCompanyProfile,
    this._searchCandidates,
    this._addCandidateBookmark,
  ) : super(const CompanyInitial()) {
    on<GetCompanyProfileEvent>(_onGetCompanyProfile);
    on<UpdateCompanyProfileEvent>(_onUpdateCompanyProfile);
    on<SearchCandidatesEvent>(_onSearchCandidates);
    on<AddCandidateBookmarkEvent>(_onAddCandidateBookmark);
  }

  Future<void> _onGetCompanyProfile(
    GetCompanyProfileEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(const CompanyLoading());
    final result = await _getCompanyProfile(event.userId);
    result.when(
      (company) => emit(CompanyLoaded(company)),
      (error) => emit(CompanyError(error)),
    );
  }

  Future<void> _onUpdateCompanyProfile(
    UpdateCompanyProfileEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(const CompanyLoading());
    final result = await _updateCompanyProfile(event.company);
    result.when(
      (company) => emit(CompanyLoaded(company)),
      (error) => emit(CompanyError(error)),
    );
  }

  Future<void> _onSearchCandidates(
    SearchCandidatesEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(const CompanyLoading());
    final result = await _searchCandidates(
      city: event.city,
      skill: event.skill,
      experience: event.experience,
    );
    result.when(
      (candidates) => emit(CandidateResults(candidates)),
      (error) => emit(CompanyError(error)),
    );
  }

  Future<void> _onAddCandidateBookmark(
    AddCandidateBookmarkEvent event,
    Emitter<CompanyState> emit,
  ) async {
    final current = state;
    if (current is! CompanyLoaded) return;

    final companyId = current.company.id;
    emit(const CompanyLoading());
    final result = await _addCandidateBookmark(companyId, event.candidateId);
    result.when(
      (_) => emit(const BookmarkAddedSuccessfully()),
      (error) => emit(CompanyError(error)),
    );
  }
}
