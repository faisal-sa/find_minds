import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/theme/theme.dart';

import 'package:graduation_project/features/individuals/engagement/presentation/widgets/engagement_section.dart';
import 'package:graduation_project/features/individuals/insights/presentation/widgets/feature_card.dart';
import 'package:graduation_project/features/individuals/insights/presentation/widgets/insights_app_bar.dart';
import 'package:graduation_project/features/individuals/insights/presentation/widgets/locked_feature_card.dart';
import 'package:graduation_project/features/individuals/shared/user/presentation/cubit/user_cubit.dart';
import 'package:graduation_project/features/individuals/shared/user/presentation/cubit/user_state.dart';
class InsightsTab extends StatelessWidget {
  const InsightsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const InsightsAppBar(),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state.resumeError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.resumeError!,
                  style: TextStyle(fontSize: 14.spMin),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            final completionRatio = state.profileCompletion;
            final completionPercent = (completionRatio * 100).toInt();
            final isComplete = completionRatio >= 0.8;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeCard(
                    userState: state,
                    isComplete: isComplete,
                    completionPercent: completionPercent,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "Your Insights",
                    style: TextStyle(
                      fontSize: 18.spMin, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  InsightsFeatureGrid(isComplete: isComplete),
                  SizedBox(height: 24.h),
                  EngagementSection(isProfileComplete: isComplete),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class WelcomeCard extends StatelessWidget {
  final UserState userState;
  final bool isComplete;
  final int completionPercent;

  const WelcomeCard({
    super.key,
    required this.userState,
    required this.isComplete,
    required this.completionPercent,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = userState.user.firstName.isNotEmpty
        ? userState.user.firstName
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
            offset: Offset(0, 10),
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.spMin, 
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            isComplete
                ? "Your profile is active and ready to match."
                : "Let's get your profile ready for top companies.",
            style: TextStyle(color: Colors.blue.shade100, fontSize: 14.spMin), 
          ),
          SizedBox(height: 24.h),

          _ProfileStrengthIndicator(
            progressPercent: completionPercent,
            completionRatio: userState.profileCompletion,
          ),

          if (!isComplete) ...[
            SizedBox(height: 24.h),
            Text(
              "NEXT STEPS",
              style: TextStyle(
                color: Colors.blue.shade100,
                fontWeight: FontWeight.bold,
                fontSize: 11.spMin, 
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 12.h),
            _ResumeUploadButton(isLoading: userState.isResumeLoading),
          ],
        ],
      ),
    );
  }
}

class _ProfileStrengthIndicator extends StatelessWidget {
  final int progressPercent;
  final double completionRatio;

  const _ProfileStrengthIndicator({
    required this.progressPercent,
    required this.completionRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration(
        color: AppColors.blueDark.withAlpha(77),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(26)),
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
                  fontSize: 12.spMin, 
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "$progressPercent% Complete",
                style: TextStyle(
                  color: Colors.blue.shade100,
                  fontSize: 12.spMin, 
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
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
                width: MediaQuery.of(context).size.width * completionRatio,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResumeUploadButton extends StatelessWidget {
  final bool isLoading;

  const _ResumeUploadButton({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading
            ? null
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
                color: Colors.black.withAlpha(26),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.w),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Analyzing PDF...",
                      style: TextStyle(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.spMin,
                      ),
                    ),
                  ],
                )
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
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Upload Resume",
                            style: TextStyle(
                              color: AppColors.textMain,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.spMin,
                            ),
                          ),
                          Text(
                            "Auto-fill 80% of profile",
                            style: TextStyle(
                              color: AppColors.textSub,
                              fontSize: 11.spMin, 
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bluePrimary,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 10.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "+100%",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.spMin,
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
    );
  }
}

class InsightsFeatureGrid extends StatelessWidget {
  final bool isComplete;

  const InsightsFeatureGrid({super.key, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: isComplete
                ? FeatureCard(
                    child: _FeatureCardContent(
                      icon: Icons.handshake,
                      iconColor: Colors.pink,
                      title: "Match Strength",
                      subtitle: "Check job fit",
                      actionText: "View Score",
                      onTap: () => context.go('/insights/match-strength'),
                    ),
                  )
                : const LockedFeatureCard(
                    icon: Icons.track_changes,
                    title: "Match Strength",
                    unlockText: "Complete profile to see scores.",
                  ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: isComplete
                ? FeatureCard(
                    child: _FeatureCardContent(
                      icon: Icons.bolt,
                      iconColor: Colors.amber,
                      title: "AI Skill Check",
                      subtitle: "Validate top skills",
                      actionText: "Start Quiz",
                      onTap: () => context.go('/insights/ai-skill-check'),
                    ),
                  )
                : const LockedFeatureCard(
                    icon: Icons.bolt,
                    title: "AI Quiz",
                    unlockText: "Generate quiz based on experience.",
                  ),
          ),
        ],
      ),
    );
  }
}
class _FeatureCardContent extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback? onTap;

  const _FeatureCardContent({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.actionText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
       
          child: Icon(icon, color: iconColor, size: 32),
        ),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.spMin),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.spMin, 
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const Spacer(),
        const SizedBox(height: 12),
        
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  actionText,
                  style: TextStyle(
                    fontSize: 12.spMin,
                    color: const Color(0xff225ae3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 14,
                  color: const Color(0xff225ae3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
