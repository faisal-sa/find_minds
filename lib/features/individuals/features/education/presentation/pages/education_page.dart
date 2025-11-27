import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/individuals/features/education/domain/entities/education.dart';
import 'package:intl/intl.dart';

import '../cubit/list/education_list_cubit.dart';
import '../cubit/list/education_list_state.dart';
import '../widgets/add_education_modal.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Education',
          style: TextStyle(color: Color(0xFF1E293B)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () => AddEducationModal.show(context, null),
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
      body: BlocBuilder<EducationListCubit, EducationListState>(
        builder: (context, state) {
          if (state.status == ListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ListStatus.failure) {
            return Center(
              child: Text(state.errorMessage ?? "Error loading data"),
            );
          }

          final educations = state.educations;

          if (educations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 48.sp,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "No education listed",
                    style: TextStyle(color: Colors.grey[500], fontSize: 16.sp),
                  ),
                  TextButton(
                    onPressed: () => AddEducationModal.show(context, null),
                    child: const Text("Add your education"),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(24.w),
            itemCount: educations.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final edu = educations[index];
              return _EducationCard(
                education: edu,
                onDelete: () =>
                    context.read<EducationListCubit>().deleteEducation(edu.id),
                onEdit: () => AddEducationModal.show(context, edu),
              );
            },
          );
        },
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  final Education education;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _EducationCard({
    required this.education,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM yyyy');
    final dateStr =
        "${fmt.format(education.startDate)} - ${fmt.format(education.endDate)}";

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${education.degreeType} in ${education.fieldOfStudy}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      education.institutionName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                    if (education.gpa != null && education.gpa!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          "GPA: ${education.gpa}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[600],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Actions Row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.blue[400],
                      size: 20.sp,
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.only(left: 8.w),
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red[300],
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Attachments Indicator
          if (education.graduationCertificate != null ||
              education.academicRecord != null)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Row(
                children: [
                  Icon(Icons.attach_file, size: 14.sp, color: Colors.grey[500]),
                  SizedBox(width: 4.w),
                  Text(
                    "Attachments available",
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),

          if (education.activities.isNotEmpty) ...[
            Divider(height: 24.h, color: Colors.grey[100]),
            Text(
              "Activities & Societies",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8.h),
            ...education.activities.map(
              (r) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: Icon(
                        Icons.circle,
                        size: 5.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        r,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
