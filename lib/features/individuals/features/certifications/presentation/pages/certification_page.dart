import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Assuming usage based on .w/.h
import 'package:graduation_project/features/individuals/features/certifications/domain/entities/certification.dart';
import 'package:graduation_project/features/individuals/features/certifications/presentation/cubit/list/certification_list_cubit.dart';
import 'package:graduation_project/features/individuals/features/certifications/presentation/cubit/list/certification_list_state.dart';
import 'package:graduation_project/features/individuals/features/certifications/presentation/widgets/add_certification_modal.dart';
import 'package:graduation_project/features/individuals/features/work_experience/presentation/cubit/list/work_experience_list_state.dart';
import 'package:intl/intl.dart';
// Import your domain/cubit files here

// -----------------------------------------------------------------------------
// PAGE
// -----------------------------------------------------------------------------

class CertificationPage extends StatelessWidget {
  const CertificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Certifications',
          style: TextStyle(color: Color(0xFF1E293B)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await AddCertificationModal.show(context, null);
              if (result != null && context.mounted) {
                context.read<CertificationListCubit>().addCertification(result);
              }
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CertificationListCubit, CertificationListState>(
        builder: (context, state) {
          if (state.status == ListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ListStatus.failure) {
            return Center(
              child: Text(state.errorMessage ?? "Error loading data"),
            );
          }

          final list = state.certifications;

          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.workspace_premium_outlined, // Changed Icon
                    size: 48.sp,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "No certifications listed",
                    style: TextStyle(color: Colors.grey[500], fontSize: 16.sp),
                  ),
                  TextButton(
                    onPressed: () async {
                      final result = await AddCertificationModal.show(
                        context,
                        null,
                      );
                      if (result != null && context.mounted) {
                        context.read<CertificationListCubit>().addCertification(
                          result,
                        );
                      }
                    },
                    child: const Text("Add a certification"),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(24.w),
            itemCount: list.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final cert = list[index];
              return _CertificationCard(
                certification: cert,
                onDelete: () => context
                    .read<CertificationListCubit>()
                    .deleteCertification(cert.id),
                onEdit: () async {
                  final result = await AddCertificationModal.show(
                    context,
                    cert,
                  );
                  if (result != null && context.mounted) {
                    context.read<CertificationListCubit>().updateCertification(
                      result,
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CARD COMPONENT
// -----------------------------------------------------------------------------

class _CertificationCard extends StatelessWidget {
  final Certification certification;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _CertificationCard({
    required this.certification,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM yyyy');

    // Logic for date display: "Issued: Jan 2023" or "Jan 2023 - Jan 2025"
    String dateStr = "Issued ${fmt.format(certification.issueDate)}";
    if (certification.expirationDate != null) {
      dateStr =
          "${fmt.format(certification.issueDate)} - ${fmt.format(certification.expirationDate!)}";
    }

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
                      certification.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      certification.issuingInstitution,
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
          if (certification.credentialFile != null)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.attach_file,
                      size: 14.sp,
                      color: Colors.blue[700],
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "Credential Attached",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.blue[700],
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
