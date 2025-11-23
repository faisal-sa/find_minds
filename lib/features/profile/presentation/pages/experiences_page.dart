import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/profile/domain/entities/work_experience.dart';
import 'package:graduation_project/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:graduation_project/features/profile/presentation/widgets/segmented_progress_bar.dart';
import 'package:graduation_project/features/profile/presentation/widgets/work_experience_modal_sheet.dart';
import 'package:intl/intl.dart';

class ExperiencesPage extends StatelessWidget {
  const ExperiencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedProgressBar(progress: 0.5),
            SizedBox(height: 20.h),
            SizedBox(height: 24.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Work Experience",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: const Color(0xffe5e7eb),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        builder: (_) {
                          return BlocProvider.value(
                            value: context.read<ProfileCubit>(),
                            child: const WorkExperienceModalSheet(),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state.experiences.isEmpty) {
                  return DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: Radius.circular(12.r),
                      color: const Color(0xffd1d5db),
                      dashPattern: [10, 7],
                      strokeWidth: 2,
                      strokeCap: StrokeCap.round,
                    ),
                    child: SizedBox(
                      width: 1.sw,
                      height: 200.h,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Your work experiences are displayed here",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text("add your past roles to show your expertise"),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.experiences.length,
                    separatorBuilder: (c, i) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      return _ExperienceCard(
                        experience: state.experiences[index],
                        onDelete: () {
                          context.read<ProfileCubit>().removeWorkExperience(
                            state.experiences[index].id,
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),

            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  "Education",
                  style: TextStyle(fontSize: 24.r, fontWeight: .bold),
                ),

                CircleAvatar(
                  backgroundColor: Color(0xffe5e7eb),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: Radius.circular(12.r),
                color: Color(0xffd1d5db),
                dashPattern: [10, 7],
                strokeWidth: 2,
                strokeCap: .round,
              ),
              child: SizedBox(
                width: 1.sw,
                height: 200.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        "No Education Added",
                        style: TextStyle(fontWeight: .w500),
                      ),
                      Text("add your degrees and certifications"),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),

            SkillsEditor(),

            SizedBox(height: 32.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(1.sw, 60.h),
                backgroundColor: Color(0xff135bec),
              ),
              onPressed: () => context.read<ProfileCubit>().nextPage(),
              child: Text(
                "Continue to Introduction",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => context.read<ProfileCubit>().previousPage(),

              child: Text("go back"),
            ),
          ],
        ),
      ),
    );
  }
}

class SkillsEditor extends StatelessWidget {
  SkillsEditor({super.key});

  final List<String> _availableSkills = [
    'Flutter',
    'Dart',
    'Java',
    'Kotlin',
    'Swift',
    'Objective-C',
    'Python',
    'JavaScript',
    'TypeScript',
    'React',
    'Node.js',
    'Git',
    'Firebase',
    'AWS',
    'Docker',
    'Kubernetes',
    'SQL',
    'NoSQL',
    'GraphQL',
    'REST API',
    'Agile',
    'Scrum',
    'Teamwork',
    'Communication',
    'Problem Solving',
    'Leadership',
    'UI/UX Design',
    'Figma',
    'Adobe XD',
    'Jira',
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Skills", style: TextStyle(color: Color(0xff878787))),
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.black,
                    onPressed: () {
                      final currentState = context.read<ProfileCubit>().state;
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0.r),
                          ),
                        ),
                        builder: (context) {
                          return BlocProvider.value(
                            value: cubit,
                            child: SkillPickerSheet(
                              allSkills: _availableSkills,
                              initialSelectedSkills: currentState.skills,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state.skills.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      'No skills added yet.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
                }

                return Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: state.skills.map((skill) {
                    return Chip(
                      label: Text(skill),
                      backgroundColor: Colors.blueAccent,
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                      deleteIcon: Icon(
                        Icons.close,
                        size: 16.r,
                        color: Colors.white,
                      ),
                      onDeleted: () {
                        cubit.removeSkill(skill);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SkillPickerSheet extends StatefulWidget {
  final List<String> allSkills;
  final List<String> initialSelectedSkills;

  const SkillPickerSheet({
    super.key,
    required this.allSkills,
    this.initialSelectedSkills = const [],
  });

  @override
  State<SkillPickerSheet> createState() => _SkillPickerSheetState();
}

class _SkillPickerSheetState extends State<SkillPickerSheet> {
  String _searchQuery = '';
  List<String> _filteredSkills = [];
  late List<String> selectedSkills;
  late final ProfileCubit cubit;

  @override
  void initState() {
    super.initState();
    _filteredSkills = List.from(widget.allSkills);
    selectedSkills = List.from(widget.initialSelectedSkills);
    cubit = context.read<ProfileCubit>();
  }

  @override
  void dispose() {
    cubit.updateSkills(selectedSkills);
    super.dispose();
  }

  void _filterSkills(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredSkills = widget.allSkills.where((skill) {
        return skill.toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: 0.65.sh,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Add Skill',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            TextField(
              autofocus: false,
              onChanged: _filterSkills,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'e.g., Flutter',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15.h,
                  horizontal: 20.w,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: _filteredSkills.isEmpty
                  ? Center(
                      child: Text(
                        'No skills found',
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredSkills.length,
                      separatorBuilder: (context, index) =>
                          Divider(height: 1.h, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        final skill = _filteredSkills[index];
                        final isSelected = selectedSkills.contains(skill);

                        return ListTile(
                          tileColor: isSelected
                              ? Colors.grey.shade50
                              : Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 4.h,
                            horizontal: 8.w,
                          ),
                          title: Text(
                            skill,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: isSelected ? Colors.grey : Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                if (isSelected) {
                                  selectedSkills.remove(skill);
                                } else {
                                  selectedSkills.add(skill);
                                }
                              });
                            },
                            icon: Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.add_circle_outline,
                              color: isSelected ? Colors.green : Colors.blue,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildEmptyState() {
  return DottedBorder(
    options: RoundedRectDottedBorderOptions(
      radius: Radius.circular(12.r),
      color: const Color(0xffd1d5db),
      dashPattern: const [10, 7],
      strokeWidth: 2,
    ),

    child: SizedBox(
      width: 1.sw,
      height: 180.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline, size: 40.sp, color: Colors.grey[400]),
            SizedBox(height: 12.h),
            Text(
              "No experience added yet",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "Add your past roles to showcase expertise",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ExperienceCard extends StatelessWidget {
  final WorkExperience experience;
  final VoidCallback onDelete;

  const _ExperienceCard({required this.experience, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM yyyy');
    final start = dateFormat.format(experience.startDate);
    final end = experience.isCurrentlyWorking
        ? "Present"
        : (experience.endDate != null
              ? dateFormat.format(experience.endDate!)
              : "N/A");

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.jobTitle,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "${experience.companyName} • ${experience.employmentType}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "$start - $end",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      experience.location,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red[400],
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: Colors.grey[200]),
          SizedBox(height: 8.h),
          if (experience.responsibilities.isNotEmpty)
            ...experience.responsibilities.map(
              (resp) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: Icon(
                        Icons.circle,
                        size: 5.sp,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        resp,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[800],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
