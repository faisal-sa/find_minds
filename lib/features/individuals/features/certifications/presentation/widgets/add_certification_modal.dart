import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/individuals/features/certifications/domain/entities/certification.dart';
import 'package:graduation_project/features/individuals/features/shared/widgets/custom_date_picker.dart';
import 'package:graduation_project/features/individuals/features/shared/widgets/custom_text_field.dart';
import 'package:graduation_project/features/individuals/features/shared/widgets/date_box.dart';
import 'package:graduation_project/features/individuals/features/shared/widgets/form_label.dart';
import 'package:uuid/uuid.dart';

class AddCertificationModal extends StatefulWidget {
  final Certification? certification;

  const AddCertificationModal({super.key, this.certification});

  static Future<Certification?> show(
    BuildContext context,
    Certification? certification,
  ) async {
    return await showModalBottomSheet<Certification>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (ctx) => AddCertificationModal(certification: certification),
    );
  }

  @override
  State<AddCertificationModal> createState() => _AddCertificationModalState();
}

class _AddCertificationModalState extends State<AddCertificationModal> {
  late TextEditingController _nameController;
  late TextEditingController _issuingInstitutionController;

  DateTime? _issueDate;
  DateTime? _expirationDate;

  // Mock file state
  bool _hasCredentialFile = false;

  @override
  void initState() {
    super.initState();
    final cert = widget.certification;
    _nameController = TextEditingController(text: cert?.name);
    _issuingInstitutionController = TextEditingController(
      text: cert?.issuingInstitution,
    );

    if (cert != null) {
      _issueDate = cert.issueDate;
      _expirationDate = cert.expirationDate;
      _hasCredentialFile = cert.credentialFile != null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuingInstitutionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.isEmpty ||
        _issuingInstitutionController.text.isEmpty ||
        _issueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Missing required fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newCertification = Certification(
      id: widget.certification?.id ?? const Uuid().v4(),
      name: _nameController.text,
      issuingInstitution: _issuingInstitutionController.text,
      issueDate: _issueDate!,
      expirationDate: _expirationDate,
      credentialFile: _hasCredentialFile
          ? File("path/to/credential.pdf")
          : null,
    );

    Navigator.pop(context, newCertification);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.certification != null;

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

          // Scrollable Form Body
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel("Certification Name"),
                  CustomTextField(
                    hint: "e.g. AWS Certified Solutions Architect",
                    icon: Icons.badge_outlined,
                    controller: _nameController,
                  ),
                  SizedBox(height: 16.h),

                  const FormLabel("Issuing Organization"),
                  CustomTextField(
                    hint: "e.g. Amazon Web Services",
                    controller: _issuingInstitutionController,
                  ),
                  SizedBox(height: 16.h),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FormLabel("Issue Date"),
                            GestureDetector(
                              onTap: () => showCustomDatePicker(
                                context: context,
                                initialDate: _issueDate,
                                onDateChanged: (d) =>
                                    setState(() => _issueDate = d),
                              ),
                              child: DateBox(
                                date: _issueDate,
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
                            const FormLabel("Expiration (Optional)"),
                            GestureDetector(
                              onTap: () => showCustomDatePicker(
                                context: context,
                                initialDate: _expirationDate,
                                onDateChanged: (d) =>
                                    setState(() => _expirationDate = d),
                              ),
                              child: DateBox(
                                date: _expirationDate,
                                placeholder: "No Expiry",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  const FormLabel("Credential File"),
                  _FileButton(
                    label: "Upload Certificate",
                    isFileSelected: _hasCredentialFile,
                    onTap: () {
                      setState(() {
                        _hasCredentialFile = !_hasCredentialFile;
                      });
                    },
                  ),

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
                    isEditing ? "Save Changes" : "Save Certification",
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
