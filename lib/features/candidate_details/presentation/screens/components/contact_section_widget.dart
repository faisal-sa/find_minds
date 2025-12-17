import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/candidate_details/domain/entities/candidate_profile_entity.dart';
import 'package:graduation_project/features/candidate_details/presentation/cubit/candidate_details_cubit.dart';

class ContactSectionWidget extends StatelessWidget {
  final CandidateProfileEntity profile;
  final String companyId;

  const ContactSectionWidget({
    super.key,
    required this.profile,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    if (profile.isUnlocked) {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified, color: Colors.green),
                Gap(8.w),
                Text(
                  "Premium Access Active",
                  style: TextStyle(
                    fontSize: 14.spMin,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildContactRow(Icons.email, profile.email ?? "Not provided"),
            Gap(10.h),
            _buildContactRow(
              Icons.phone,
              profile.phoneNumber ?? "Not provided",
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(Icons.lock_outline, size: 40.sp, color: Colors.grey),
            Gap(10.h),
            Text(
              "Access Locked",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Pay once to unlock ALL candidate profiles.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            Gap(15.h),
            ElevatedButton(
              onPressed: () => _handleUnlock(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              ),
              child: const Text("Get Unlimited Access"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _handleUnlock(BuildContext context) async {
    final bool? paymentSuccess = await context.push<bool>('/company/payment');
    if (paymentSuccess == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Upgrade Successful!'),
          backgroundColor: Colors.green,
        ),
      );
      context.read<CandidateProfileCubit>().unlockProfile(
        candidateId: profile.id,
        companyId: companyId,
      );
    }
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green),
        Gap(10.w),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
