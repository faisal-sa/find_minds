import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/core/di/service_locator.dart';
import 'package:graduation_project/features/individuals/features/education/domain/entities/education.dart';
import 'package:intl/intl.dart';

import '../cubit/form/education_form_cubit.dart';
import '../cubit/form/education_form_state.dart';
import '../cubit/list/education_list_cubit.dart';

class AddEducationModal extends StatelessWidget {
  final bool isEditing;
  const AddEducationModal({super.key, this.isEditing = false});

  static void show(BuildContext context, Education? education) {
    final listCubit = context.read<EducationListCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (ctx) {
        // Assuming GetIt or similar is used
        final formCubit = serviceLocator.get<EducationFormCubit>();

        if (education != null) {
          formCubit.initializeForEdit(education);
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: formCubit),
            BlocProvider.value(value: listCubit),
          ],
          child: AddEducationModal(isEditing: education != null),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EducationFormCubit, EducationFormState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          Navigator.pop(context);
          context.read<EducationListCubit>().loadEducations();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing ? "Education Updated" : "Education Added",
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
            // Handle Bar
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
                    isEditing ? "Edit Education" : "Add Education",
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

            // Scrollable Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: const _EducationFormBody(),
              ),
            ),

            // Sticky Bottom Button
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
                  child: BlocBuilder<EducationFormCubit, EducationFormState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.status == FormStatus.loading
                            ? null
                            : () => context
                                  .read<EducationFormCubit>()
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
                                isEditing ? "Save Changes" : "Save Education",
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

class _EducationFormBody extends StatefulWidget {
  const _EducationFormBody();

  @override
  State<_EducationFormBody> createState() => _EducationFormBodyState();
}

class _EducationFormBodyState extends State<_EducationFormBody> {
  final _activityController = TextEditingController();

  void _showDatePicker(BuildContext context, bool isStart) {
    final cubit = context.read<EducationFormCubit>();
    final initial = isStart
        ? (cubit.state.startDate ?? DateTime.now())
        : (cubit.state.endDate ?? DateTime.now());

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
                mode: CupertinoDatePickerMode.monthYear,
                onDateTimeChanged: (val) => isStart
                    ? cubit.startDateChanged(val)
                    : cubit.endDateChanged(val),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // We can use TextControllers initialized with state values if we want initial values to show up,
    // but simplified _TextField widget here handles basic onChange.
    // Note: For editing text fields correctly in stateless/bloc, controllers are often better,
    // but sticking to the provided pattern:

    // To properly show initial values for Editing, we need the state.
    // Since _TextField in the original example didn't use controller for initial text,
    // we assume the user types or we'd need to set initialValue.

    return BlocBuilder<EducationFormCubit, EducationFormState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Label("Institution Name"),
            _TextField(
              hint: "e.g. Harvard University",
              icon: Icons.account_balance,
              initialValue: state.institutionName,
              onChanged: (v) =>
                  context.read<EducationFormCubit>().institutionNameChanged(v),
            ),
            SizedBox(height: 16.h),

            _Label("Degree Type"),
            _TextField(
              hint: "e.g. Bachelor's",
              initialValue: state.degreeType,
              onChanged: (v) =>
                  context.read<EducationFormCubit>().degreeTypeChanged(v),
            ),
            SizedBox(height: 16.h),

            _Label("Field of Study"),
            _TextField(
              hint: "e.g. Computer Science",
              initialValue: state.fieldOfStudy,
              onChanged: (v) =>
                  context.read<EducationFormCubit>().fieldOfStudyChanged(v),
            ),
            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label("Start Date"),
                      GestureDetector(
                        onTap: () => _showDatePicker(context, true),
                        child: _DateBox(
                          date: state.startDate,
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
                      _Label("End Date (or Expected)"),
                      GestureDetector(
                        onTap: () => _showDatePicker(context, false),
                        child: _DateBox(
                          date: state.endDate,
                          placeholder: "Select",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            _Label("GPA (Optional)"),
            _TextField(
              hint: "e.g. 3.8/4.0",
              initialValue: state.gpa,
              onChanged: (v) =>
                  context.read<EducationFormCubit>().gpaChanged(v),
            ),
            SizedBox(height: 16.h),

            // Attachments UI Mock
            _Label("Attachments"),
            Row(
              children: [
                Expanded(
                  child: _FileButton(
                    label: "Graduation Cert.",
                    isFileSelected: state.graduationCertificate != null,
                    onTap: () {
                      // Trigger file picker logic here
                      // context.read<EducationFormCubit>().setGraduationCertificate(file);
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _FileButton(
                    label: "Academic Record",
                    isFileSelected: state.academicRecord != null,
                    onTap: () {
                      // Trigger file picker logic here
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            _Label("Activities & Societies"),
            Row(
              children: [
                Expanded(
                  child: _TextField(
                    controller: _activityController,
                    hint: "Add activity...",
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton.filled(
                  onPressed: () {
                    context.read<EducationFormCubit>().addActivity(
                      _activityController.text,
                    );
                    _activityController.clear();
                  },
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(backgroundColor: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            if (state.activities.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: state.activities
                      .asMap()
                      .entries
                      .map(
                        (e) => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 6,
                                color: Colors.black54,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  e.value,
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                              ),
                              InkWell(
                                onTap: () => context
                                    .read<EducationFormCubit>()
                                    .removeActivity(e.key),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            // Add extra padding for scroll comfort
            SizedBox(height: 100.h),
          ],
        );
      },
    );
  }
}

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
  final String?
  initialValue; // Added to support editing pre-fill without controller management

  const _TextField({
    this.hint = '',
    this.icon,
    this.onChanged,
    this.controller,
    this.initialValue,
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
