import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/individuals/profile/routes/certifications/domain/entities/certification.dart';
import 'package:graduation_project/features/individuals/shared/widgets/custom_text_field.dart';
import 'package:graduation_project/features/individuals/shared/widgets/form_label.dart';
import 'package:graduation_project/features/individuals/shared/widgets/shared_things.dart';
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

  // CHANGED: Use PlatformFile for new picks and a bool to track removal of existing
  PlatformFile? _pickedFile;
  bool _isExistingFileRemoved = false;

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
      // We don't pre-fill _pickedFile because that's only for NEW user actions.
      // We rely on widget.certification.credentialFile for the existing state.
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuingInstitutionController.dispose();
    super.dispose();
  }

  // ADDED: Real file picking logic
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _pickedFile = result.files.first;
          _isExistingFileRemoved =
              false; // Reset removal if they pick a new one
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to pick file: $e")));
      }
    }
  }

  // ADDED: Logic to clear the file
  void _clearFile() {
    setState(() {
      _pickedFile = null;
      _isExistingFileRemoved = true;
    });
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

    File? fileToSave;
    String? urlToSave =
        widget.certification?.credentialUrl; // Default to existing URL

    // 1. If a new file was picked
    if (_pickedFile != null && _pickedFile!.path != null) {
      fileToSave = File(_pickedFile!.path!);
      urlToSave =
          null; // Clear URL because we have a new local file waiting to upload
    }
    // 2. If removed explicitly
    else if (_isExistingFileRemoved) {
      fileToSave = null;
      urlToSave = null;
    }
    // 3. Else (No change), keep existing fileToSave (if local) or urlToSave (if remote) stays as is.

    final newCertification = Certification(
      id: widget.certification?.id ?? const Uuid().v4(),
      name: _nameController.text,
      issuingInstitution: _issuingInstitutionController.text,
      issueDate: _issueDate!,
      expirationDate: _expirationDate,
      credentialFile: fileToSave,
      credentialUrl: urlToSave, // Pass this back so we don't lose it!
    );

    Navigator.pop(context, newCertification);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.certification != null;

    // --- FIX: Check both Local File AND Remote URL ---
    final bool hasLocalFile =
        !_isExistingFileRemoved && widget.certification?.credentialFile != null;
    final bool hasRemoteUrl =
        !_isExistingFileRemoved && widget.certification?.credentialUrl != null;

    final bool hasExistingFile = hasLocalFile || hasRemoteUrl;

    final String? existingFileIndicator = hasExistingFile
        ? "Existing File"
        : null;

    return BaseFormSheet(
      title: isEditing ? "Edit Certification" : "Add Certification",
      submitLabel: isEditing ? "Save Changes" : "Save Certification",
      onSubmit: _submit,
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

          FormDateRow(
            startLabel: "Issue Date",
            startDate: _issueDate,
            onStartChanged: (d) => setState(() => _issueDate = d),
            endLabel: "Expiration (Optional)",
            endDate: _expirationDate,
            onEndChanged: (d) => setState(() => _expirationDate = d),
            endPlaceholder: "No Expiry",
          ),
          SizedBox(height: 16.h),

          const FormLabel("Credential File"),
          FormFileUploadButton(
            label: "Upload Certificate",
            file: _pickedFile, // Pass the new platform file
            existingUrl:
                existingFileIndicator, // Pass indicator for existing file
            onTap: _pickFile, // Trigger the picker
            onClear: (_pickedFile != null || hasExistingFile)
                ? _clearFile 
                : null,
          ),
        ],
      ),
    );
  }
}
