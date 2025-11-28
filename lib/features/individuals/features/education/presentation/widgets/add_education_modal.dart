import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/individuals/features/education/domain/entities/education.dart';
import 'package:graduation_project/features/individuals/features/shared/widgets/custom_text_field.dart';
import 'package:graduation_project/features/individuals/features/shared/widgets/date_selection_row.dart';
import 'package:graduation_project/features/individuals/features/shared/widgets/dynamic_list_section.dart';
import 'package:graduation_project/features/individuals/features/shared/widgets/form_label.dart';
import 'package:uuid/uuid.dart';

class AddEducationModal extends StatefulWidget {
  final Education? education;

  const AddEducationModal({super.key, this.education});

  static Future<Education?> show(
    BuildContext context,
    Education? education,
  ) async {
    return await showModalBottomSheet<Education>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (ctx) => AddEducationModal(education: education),
    );
  }

  @override
  State<AddEducationModal> createState() => _AddEducationModalState();
}

class _AddEducationModalState extends State<AddEducationModal> {
  late TextEditingController _institutionController;
  late TextEditingController _degreeController;
  late TextEditingController _fieldOfStudyController;
  late TextEditingController _gpaController;

  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _activities = [];

  // Mock attachments state
  bool _hasGradCertificate = false;
  bool _hasAcademicRecord = false;

  @override
  void initState() {
    super.initState();
    final edu = widget.education;
    _institutionController = TextEditingController(text: edu?.institutionName);
    _degreeController = TextEditingController(text: edu?.degreeType);
    _fieldOfStudyController = TextEditingController(text: edu?.fieldOfStudy);
    _gpaController = TextEditingController(text: edu?.gpa);

    if (edu != null) {
      _startDate = edu.startDate;
      _endDate = edu.endDate;
      _activities = List.from(edu.activities);
      _hasGradCertificate = edu.graduationCertificate != null;
      _hasAcademicRecord = edu.academicRecord != null;
    }
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _fieldOfStudyController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_institutionController.text.isEmpty ||
        _degreeController.text.isEmpty ||
        _fieldOfStudyController.text.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Missing required fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newEducation = Education(
      id: widget.education?.id ?? const Uuid().v4(),
      institutionName: _institutionController.text,
      degreeType: _degreeController.text,
      fieldOfStudy: _fieldOfStudyController.text,
      startDate: _startDate!,
      endDate: _endDate!,
      gpa: _gpaController.text,
      activities: _activities,
      // Mocking file paths if selected
      graduationCertificate: _hasGradCertificate
          ? File("path/to/grad_cert.pdf")
          : null,
      academicRecord: _hasAcademicRecord
          ? File("path/to/academic_record.pdf")
          : null,
    );

    Navigator.pop(context, newEducation);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.education != null;

    return Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel("Institution Name"),
                  CustomTextField(
                    hint: "e.g. Harvard University",
                    icon: Icons.account_balance,
                    controller: _institutionController,
                  ),
                  SizedBox(height: 16.h),

                  const FormLabel("Degree Type"),
                  CustomTextField(
                    hint: "e.g. Bachelor's",
                    controller: _degreeController,
                  ),
                  SizedBox(height: 16.h),

                  const FormLabel("Field of Study"),
                  CustomTextField(
                    hint: "e.g. Computer Science",
                    controller: _fieldOfStudyController,
                  ),
                  SizedBox(height: 16.h),

                  DateSelectionRow(
                    startDate: _startDate,
                    endDate: _endDate,
                    isCurrentlyWorking: false,
                    onStartDateChanged: (d) => setState(() => _startDate = d),
                    onEndDateChanged: (d) => setState(() => _endDate = d),
                  ),
                  SizedBox(height: 16.h),

                  const FormLabel("GPA (Optional)"),
                  CustomTextField(
                    hint: "e.g. 3.8/4.0",
                    controller: _gpaController,
                  ),
                  SizedBox(height: 16.h),

                  // Attachments UI Mock
                  const FormLabel("Attachments"),
                  Row(
                    children: [
                      Expanded(
                        child: _FileButton(
                          label: "Graduation Cert.",
                          isFileSelected: _hasGradCertificate,
                          onTap: () {
                            setState(() {
                              _hasGradCertificate = !_hasGradCertificate;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _FileButton(
                          label: "Academic Record",
                          isFileSelected: _hasAcademicRecord,
                          onTap: () {
                            setState(() {
                              _hasAcademicRecord = !_hasAcademicRecord;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  DynamicListSection(
                    title: "Activities & Societies",
                    hintText: "Add activity...",
                    items: _activities,
                    onChanged: (list) => setState(() => _activities = list),
                  ),
                  // Add extra padding for scroll comfort
                  SizedBox(height: 100.h),
                ],
              ),
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
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    isEditing ? "Save Changes" : "Save Education",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
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
          border: Border.all(
            color: isFileSelected ? Colors.green : Colors.grey[300]!,
            width: 1,
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
