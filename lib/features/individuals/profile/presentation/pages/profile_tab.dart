import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/individuals/profile/presentation/cubit/profile_cubit.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileNavigateTo) {
          // context.push(state.route);
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
    return Column(
      children: [
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
                child: Icon(Icons.person, size: 60, color: Colors.grey[400]),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
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
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Welcome, User!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Add your job title",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Add your location",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
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
