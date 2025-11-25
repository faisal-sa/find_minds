import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/individuals/profile/presentation/cubit/profile_cubit.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileNavigateTo) {
          context.push(state.route);
          debugPrint("Navigating to: ${state.route}");
        }
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const _ProfileHeader(),
              const SizedBox(height: 30),
              const _ProfileCompletionBar(),
              const SizedBox(height: 30),

              ProfileMenuItem(
                icon: Icons.person_outline,
                title: 'Basic Information',
                subtitle: 'Add your name, location, and contact info',
                onTap: () => context.read<ProfileCubit>().onBasicInfoTapped(),
              ),
              ProfileMenuItem(
                icon: Icons.badge_outlined,
                title: 'About Me',
                subtitle: 'Write a summary or add a video intro',
                onTap: () => context.read<ProfileCubit>().onAboutMeTapped(),
              ),
              ProfileMenuItem(
                icon: Icons.work_outline,
                title: 'Work Experience',
                subtitle: 'Add your past jobs and internships',
                onTap: () =>
                    context.read<ProfileCubit>().onWorkExperienceTapped(),
              ),
              ProfileMenuItem(
                icon: Icons.school_outlined,
                title: 'Education & Certifications',
                subtitle: 'Add degrees, courses, and certificates',
                onTap: () => context.read<ProfileCubit>().onEducationTapped(),
              ),
              ProfileMenuItem(
                icon: Icons.translate,
                title: 'Skills & Languages',
                subtitle: 'List your technical skills and languages',
                onTap: () => context.read<ProfileCubit>().onSkillsTapped(),
              ),
              ProfileMenuItem(
                icon: Icons.description_outlined,
                title: 'Job Preferences',
                subtitle: 'Set your target role and salary expectations',
                onTap: () =>
                    context.read<ProfileCubit>().onJobPreferencesTapped(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    // 1. Wrap in BlocBuilder to listen for data changes
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // MOCK DATA: Replace these with actual data from your 'state'
        // String? name = state.user?.name;
        // String? jobTitle = state.user?.jobTitle;
        // String? location = state.user?.location;

        // For demonstration, let's pretend:
        const String? name = null; // Change to null to test empty
        const String? jobTitle = null; // Currently empty
        const String? location = null;

        return Column(
          children: [
            // --- AVATAR SECTION (Kept from previous step) ---
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[200],
                    // Logic: Show Image if exists, else Icon
                    backgroundImage: null,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Trigger Photo Upload
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB),
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(color: Colors.white, width: 3),
                        ),
                      ),
                      child: const Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- NAME SECTION ---
            if (name != null && name.isNotEmpty)
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
              )
            else
              // GUEST/EMPTY NAME STATE - Looks like a premium button
              GestureDetector(
                onTap: () => context.read<ProfileCubit>().onBasicInfoTapped(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF), // Blue-50
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFFDBEAFE),
                      width: 1,
                    ), // Blue-100
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Add Your Name",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2563EB), // Primary Blue
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Color(0xFF2563EB),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),

            // --- JOB TITLE SECTION ---
            // If job exists, show text. If not, show an "Add" button
            if (jobTitle != null && jobTitle.isNotEmpty)
              Text(
                jobTitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              )
            else
              _EmptyStateChip(
                icon: Icons.work_outline,
                label: "Add Job Title",
                onTap: () => context.read<ProfileCubit>().onBasicInfoTapped(),
              ),

            const SizedBox(height: 6),

            // --- LOCATION SECTION ---
            if (location != null && location.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              )
            else
              _EmptyStateChip(
                icon: Icons.location_on_outlined,
                label: "Add Location",
                onTap: () => context.read<ProfileCubit>().onBasicInfoTapped(),
              ),
          ],
        );
      },
    );
  }
}

// Helper Widget to make the "Empty" state look good
class _EmptyStateChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _EmptyStateChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF), // Light Blue background
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFBFDBFE)), // Blue border
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF2563EB)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2563EB), // Blue text
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCompletionBar extends StatelessWidget {
  const _ProfileCompletionBar();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Profile Completion",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              "0%",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: const LinearProgressIndicator(
            value: 0.0,
            minHeight: 8,
            backgroundColor: Color(0xFFE5E7EB),
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Complete your profile to get noticed by recruiters.",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF2563EB), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.add_circle_outline, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
