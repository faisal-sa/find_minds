import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/di/service_locator.dart';
import 'package:graduation_project/core/theme/theme.dart';
import 'package:graduation_project/core/usecasesAbstract/no_params.dart';
import 'package:graduation_project/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:graduation_project/features/individuals/engagement/presentation/widgets/engagement_section.dart';
import 'package:graduation_project/features/individuals/insights/presentation/widgets/feature_card.dart';
import 'package:graduation_project/features/individuals/insights/presentation/widgets/locked_feature_card.dart';
import 'package:graduation_project/features/shared/user_cubit.dart';
import 'package:graduation_project/features/shared/user_state.dart';

class InsightsTab extends StatelessWidget {
  const InsightsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _InsightsAppBar(),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state.resumeError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.resumeError!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            final userEntity = state.user;
            final completionRatio = state.profileCompletion;
            final completionPercent = (completionRatio * 100).toInt();
            final isComplete = completionRatio >= 0.8;

            return SingleChildScrollView(
           
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCard(
                    context,
                    state,
                    isComplete,
                    completionPercent,
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    "Your Insights",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: isComplete
                              ? FeatureCard(
                                  onTap: () {
                                    context.go('/insights/match-strength');
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Center(
                                        child: Icon(
                                          Icons.handshake,
                                          color: Colors.pink,
                                          size: 32.r,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Match Strength",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.r,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            "Check job fit",
                                            style: TextStyle(
                                              fontSize: 11.r,
                                              color: AppColors.textSub,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "View Score",
                                            style: TextStyle(
                                              fontSize: 12.r,
                                              color: AppColors.bluePrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 4.h),
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 14.r,
                                            color: AppColors.bluePrimary,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : const LockedFeatureCard(
                                  icon: Icons.track_changes,
                                  title: "Match Strength",
                                  unlockText: "Complete profile to see scores.",
                                ),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: isComplete
                              ? FeatureCard(
                                  onTap: () {
                                    context.go('/insights/ai-skill-check');
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Center(
                                        child: Icon(
                                          Icons.bolt,
                                          color: Colors.amber,
                                          size: 32.r,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "AI Skill Check",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.r,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            "Validate top skills",
                                            style: TextStyle(
                                              fontSize: 11.r,
                                              color: AppColors.textSub,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Start Quiz",
                                            style: TextStyle(
                                              fontSize: 12.r,
                                              color: AppColors.bluePrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 14.r,
                                            color: AppColors.bluePrimary,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : const LockedFeatureCard(
                                  icon: Icons.bolt,
                                  title: "AI Quiz",
                                  unlockText:
                                      "Generate quiz based on experience.",
                                ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  EngagementSection(isProfileComplete: isComplete),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(
    BuildContext context,
    UserState state,
    bool isComplete,
    int progressPercent,
  ) {
    final displayName = state.user.firstName.isNotEmpty
        ? state.user.firstName
        : "User";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bluePrimary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.bluePrimary.withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isComplete
                ? "Welcome back, $displayName! 👋"
                : "Welcome to FINDMinds! 👋",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isComplete
                ? "Your profile is active and ready to match."
                : "Let's get your profile ready for top companies.",
            style: TextStyle(color: Colors.blue.shade100, fontSize: 14),
          ),
          const SizedBox(height: 24),

          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.blueDark.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile Strength",
                      style: TextStyle(
                        color: Colors.blue.shade100,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "$progressPercent% Complete",
                      style: TextStyle(
                        color: Colors.blue.shade100,
                        fontSize: 12.r,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.blueDark,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeOutExpo,
                      height: 8,
                      width:
                          MediaQuery.of(context).size.width *
                          state.profileCompletion *
                          0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (!isComplete) ...[
            const SizedBox(height: 24),
            Text(
              "NEXT STEPS",
              style: TextStyle(
                color: Colors.blue.shade100,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            // 2. Updated Upload Section
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: state.isResumeLoading
                    ? null // Disable tap while loading
                    : () {
                        context.read<UserCubit>().uploadAndExtractResume();
                      },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: state.isResumeLoading
                      // 3. Loading State UI
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Analyzing PDF...",
                              style: TextStyle(
                                color: AppColors.textMain,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      // Normal UI
                      : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.blueLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.upload_file,
                                color: AppColors.bluePrimary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Upload Resume",
                                    style: TextStyle(
                                      color: AppColors.textMain,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "Auto-fill 80% of profile",
                                    style: TextStyle(
                                      color: AppColors.textSub,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.bluePrimary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: Colors.white,
                                    size: 10,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "+100%",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}


class _InsightsAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const _InsightsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0XFFf1f5f9),
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Clickable Avatar -> Navigates to Profile
          GestureDetector(
            onTap: () {
              // Navigate to the Profile branch
              context.go('/profile');
            },
            child: CircleAvatar(
              backgroundColor: AppColors.blueLight,
              child: Icon(Icons.person, color: AppColors.bluePrimary),
            ),
          ),

          // 2. Logout Button
          IconButton(
            onPressed: () {
              serviceLocator.get<AuthCubit>().signOut.call(NoParams());
              context.go("/");
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}
