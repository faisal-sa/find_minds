import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:graduation_project/features/company_portal/domain/entities/company_entity.dart';

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

  // -------------------- Handlers --------------------

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

    // Convert Entity → Model
    final model = CompanyModel.fromEntity(event.company);

    // Apply updates (copyWith)
    final updatedModel = model.copyWith(
      companyName: event.company.companyName,
      industry: event.company.industry,
      description: event.company.description,
      city: event.company.city,
      address: event.company.address,
      companySize: event.company.companySize,
      website: event.company.website,
      phone: event.company.phone,
      logoUrl: event.company.logoUrl,
    );

    // Convert back to Entity
    final updatedEntity = updatedModel.toEntity();

    final result = await _updateCompanyProfile(updatedEntity);

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
