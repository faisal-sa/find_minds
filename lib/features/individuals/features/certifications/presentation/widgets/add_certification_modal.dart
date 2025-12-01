// -----------------------------------------------------------------------------
// MODAL (Add/Edit)
// -----------------------------------------------------------------------------

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/di/service_locator.dart';
import 'package:graduation_project/features/individuals/features/about_me/presentation/cubit/about_me_state.dart';
import 'package:graduation_project/features/individuals/features/certifications/domain/entities/certification.dart';
import 'package:graduation_project/features/individuals/features/certifications/presentation/cubit/form/certification_form_cubit.dart';
import 'package:graduation_project/features/individuals/features/certifications/presentation/cubit/form/certification_form_state.dart';
import 'package:graduation_project/features/individuals/features/certifications/presentation/cubit/list/certification_list_cubit.dart';
import 'package:intl/intl.dart';

class AddCertificationModal extends StatelessWidget {
  final bool isEditing;
  const AddCertificationModal({super.key, this.isEditing = false});

  static void show(BuildContext context, Certification? certification) {
    final listCubit = context.read<CertificationListCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (ctx) {
        // Assuming GetIt or similar
        final formCubit = serviceLocator.get<CertificationFormCubit>();

        if (certification != null) {
          formCubit.initializeForEdit(certification);
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: formCubit),
            BlocProvider.value(value: listCubit),
          ],
          child: AddCertificationModal(isEditing: certification != null),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CertificationFormCubit, CertificationFormState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          Navigator.pop(context);
          context.read<CertificationListCubit>().loadCertifications();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing ? "Certification Updated" : "Certification Added",
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == FormStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? "Error"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 12.h),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? "Edit Certification" : "Add Certification",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: const _CertificationFormBody(),
              ),
            ),

            // Submit Button
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child:
                      BlocBuilder<
                        CertificationFormCubit,
                        CertificationFormState
                      >(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state.status == FormStatus.loading
                                ? null
                                : () => context
                                      .read<CertificationFormCubit>()
                                      .submitForm(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                            ),
                            child: state.status == FormStatus.loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    isEditing
                                        ? "Save Changes"
                                        : "Save Certification",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          );
                        },
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CertificationFormBody extends StatelessWidget {
  const _CertificationFormBody();

  void _showDatePicker(BuildContext context, bool isIssueDate) {
    final cubit = context.read<CertificationFormCubit>();
    final initial = isIssueDate
        ? (cubit.state.issueDate ?? DateTime.now())
        : (cubit.state.expirationDate ?? DateTime.now());

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) => SizedBox(
        height: 250.h,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: initial,
                mode: CupertinoDatePickerMode.date, // or monthYear
                onDateTimeChanged: (val) => isIssueDate
                    ? cubit.issueDateChanged(val)
                    : cubit.expirationDateChanged(val),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CertificationFormCubit, CertificationFormState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Label("Certification Name"),
            _TextField(
              hint: "e.g. AWS Certified Solutions Architect",
              icon: Icons.badge_outlined,
              initialValue: state.name,
              onChanged: (v) =>
                  context.read<CertificationFormCubit>().nameChanged(v),
            ),
            SizedBox(height: 16.h),

            _Label("Issuing Organization"),
            _TextField(
              hint: "e.g. Amazon Web Services",
              initialValue: state.issuingInstitution,
              onChanged: (v) => context
                  .read<CertificationFormCubit>()
                  .issuingInstitutionChanged(v),
            ),
            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label("Issue Date"),
                      GestureDetector(
                        onTap: () => _showDatePicker(context, true),
                        child: _DateBox(
                          date: state.issueDate,
                          placeholder: "Select",
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label("Expiration (Optional)"),
                      GestureDetector(
                        onTap: () => _showDatePicker(context, false),
                        child: _DateBox(
                          date: state.expirationDate,
                          placeholder: "No Expiry",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            _Label("Credential File"),
            _FileButton(
              label: "Upload Certificate",
              isFileSelected: state.credentialFile != null,
              onTap: () {
                // Trigger file picker
                // context.read<CertificationFormCubit>().setCredentialFile(file);
              },
            ),

            SizedBox(height: 100.h),
          ],
        );
      },
    );
  }
}

// Reuse the helpers (_Label, _TextField, _DateBox, _FileButton, _inputDeco)
// from your Education code here. They are identical.

// -----------------------------------------------------------------------------
// HELPER WIDGETS
// -----------------------------------------------------------------------------

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.grey[800],
      ),
    ),
  );
}

class _TextField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final String? initialValue;

  const _TextField({
    this.controller,
    this.hint = '',
    this.icon,
    this.onChanged,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    initialValue: initialValue,
    controller: controller,
    onChanged: onChanged,
    style: TextStyle(fontSize: 14.sp),
    decoration: _inputDeco(hint: hint, icon: icon),
  );
}

class _DateBox extends StatelessWidget {
  final DateTime? date;
  final String placeholder;
  const _DateBox({this.date, required this.placeholder});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date == null ? placeholder : DateFormat('MMM yyyy').format(date!),
            style: TextStyle(
              color: date == null ? Colors.grey[400] : Colors.black87,
              fontSize: 14.sp,
            ),
          ),
          Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey[500]),
        ],
      ),
    );
  }
}

class _FileButton extends StatelessWidget {
  final String label;
  final bool isFileSelected;
  final VoidCallback onTap;

  const _FileButton({
    required this.label,
    required this.isFileSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isFileSelected ? Colors.green.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          // Fixed: Only one border definition
          border: Border.all(
            color: isFileSelected ? Colors.green : Colors.grey[300]!,
            width: 1,
            // To mimic the dashed look without a plugin, we just use solid for now
            // or style: BorderStyle.solid is default.
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isFileSelected ? Icons.check_circle : Icons.upload_file,
              color: isFileSelected ? Colors.green : Colors.grey[500],
              size: 20.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              isFileSelected ? "Selected" : label,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _inputDeco({required String hint, IconData? icon}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
    prefixIcon: icon != null
        ? Icon(icon, size: 20.sp, color: Colors.grey[500])
        : null,
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: Colors.black87, width: 1.5),
    ),
  );
}
