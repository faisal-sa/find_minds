import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/company_bookmarks/presentation/blocs/bloc/bookmarks_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/di/service_locator.dart';

import 'components/bookmark_candidate_card.dart';
import 'components/empty_bookmarks_view.dart';

class CompanyBookmarksPage extends StatefulWidget {
  const CompanyBookmarksPage({super.key});

  @override
  State<CompanyBookmarksPage> createState() => _CompanyBookmarksPageState();
}

class _CompanyBookmarksPageState extends State<CompanyBookmarksPage> {
  @override
  void initState() {
    super.initState();
    _fetchBookmarks();
  }

  void _fetchBookmarks() {
    final userId = serviceLocator.get<SupabaseClient>().auth.currentUser?.id;
    if (userId != null) {
      context.read<BookmarksBloc>().add(LoadBookmarksEvent(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF8F9FD);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocConsumer<BookmarksBloc, BookmarksState>(
        listener: (context, state) {
          if (state is BookmarkOperationSuccess) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              style: ToastificationStyle.flatColored,
              title: const Text('Candidate Removed'),
              autoCloseDuration: const Duration(seconds: 3),
              alignment: Alignment.bottomCenter,
            );
          }
          if (state is BookmarksError) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored,
              title: const Text('Error'),
              description: Text(state.message),
              autoCloseDuration: const Duration(seconds: 4),
              alignment: Alignment.topCenter,
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // 1. App Bar
              SliverAppBar.medium(
                backgroundColor: backgroundColor,
                surfaceTintColor: Colors.transparent,
                title: const Text(
                  'Saved Candidates',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    onPressed: _fetchBookmarks,
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Refresh',
                  ),
                ],
              ),

              if (state is BookmarksLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is BookmarksLoaded)
                if (state.bookmarks.isEmpty)
                  const SliverFillRemaining(child: EmptyBookmarksView())
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final candidate = state.bookmarks[index];

                        return BookmarkCandidateCard(
                          candidate: candidate,
                          onRemove: () {
                            final userId = serviceLocator
                                .get<SupabaseClient>()
                                .auth
                                .currentUser
                                ?.id;
                            if (userId != null) {
                              context.read<BookmarksBloc>().add(
                                RemoveBookmarkEvent(
                                  candidateId: candidate.id,
                                  companyId: userId,
                                ),
                              );
                            }
                          },
                        );
                      }, childCount: state.bookmarks.length),
                    ),
                  )
              else
                const SliverFillRemaining(child: EmptyBookmarksView()),
            ],
          );
        },
      ),
    );
  }
}
