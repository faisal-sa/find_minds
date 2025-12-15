import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/company_bookmarks/domain/usecases/add_candidate_bookmark.dart';
import 'package:graduation_project/features/company_bookmarks/domain/usecases/get_company_bookmarks.dart';
import 'package:graduation_project/features/company_bookmarks/domain/usecases/remove_candidate_bookmark.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/data/domain/entities/candidate_entity.dart';

part 'bookmarks_event.dart';
part 'bookmarks_state.dart';

@injectable
class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final GetBookmarksUseCase _getCompanyBookmarks;
  final AddCandidateBookmark _addCandidateBookmark;
  final RemoveBookmarkUseCase _removeCandidateBookmark;

  BookmarksBloc(
    this._getCompanyBookmarks,
    this._addCandidateBookmark,
    this._removeCandidateBookmark,
  ) : super(BookmarksInitial()) {
    on<LoadBookmarksEvent>(_onLoadBookmarks);
    on<RemoveBookmarkEvent>(_onRemoveBookmark);
    on<AddBookmarkEvent>(_onAddBookmark);
  }

  Future<void> _onLoadBookmarks(
    LoadBookmarksEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    emit(BookmarksLoading());
    final result = await _getCompanyBookmarks(event.companyId);

    result.when(
      (bookmarks) => emit(BookmarksLoaded(bookmarks)),
      (failure) => emit(BookmarksError(failure.message)),
    );
  }

  Future<void> _onRemoveBookmark(
    RemoveBookmarkEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    List<CandidateEntity> originalList = [];
    if (state is BookmarksLoaded) {
      originalList = (state as BookmarksLoaded).bookmarks;
      final updatedList = originalList
          .where((c) => c.id != event.candidateId)
          .toList();
      emit(BookmarksLoaded(updatedList));
    }

    final result = await _removeCandidateBookmark(
      event.companyId,
      event.candidateId,
    );

    result.when(
      (success) {
        emit(const BookmarkOperationSuccess("Removed successfully"));
        if (state is! BookmarksLoaded && originalList.isNotEmpty) {
          final updatedList = originalList
              .where((c) => c.id != event.candidateId)
              .toList();
          emit(BookmarksLoaded(updatedList));
        }
      },
      (failure) {
        emit(BookmarksError("Failed to delete: ${failure.message}"));
        if (originalList.isNotEmpty) {
          emit(BookmarksLoaded(originalList));
        }
      },
    );
  }

  Future<void> _onAddBookmark(
    AddBookmarkEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    final result = await _addCandidateBookmark(
      event.companyId,
      event.candidateId,
    );

    result.when(
      (success) => emit(const BookmarkOperationSuccess("Candidate saved")),
      (failure) => emit(BookmarksError(failure.message)),
    );
  }
}
