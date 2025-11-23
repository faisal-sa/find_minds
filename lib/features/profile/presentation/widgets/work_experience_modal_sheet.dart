import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/features/profile/domain/entities/work_experience.dart';
import 'package:graduation_project/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:intl/intl.dart';

class WorkExperienceModalSheet extends StatefulWidget {
  const WorkExperienceModalSheet({super.key});

  @override
  State<WorkExperienceModalSheet> createState() =>
      _WorkExperienceModalSheetState();
}

class _WorkExperienceModalSheetState extends State<WorkExperienceModalSheet> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _jobRoleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _resItemController = TextEditingController();

  final List<String> _responsibilitiesList = [];

  String? _selectedEmploymentType;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrentlyWorking = false;

  final List<String> _employmentTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Freelance',
    'Internship',
  ];

  void _addResponsibility() {
    if (_resItemController.text.trim().isNotEmpty) {
      setState(() {
        _responsibilitiesList.add(_resItemController.text.trim());
        _resItemController.clear();
      });
    }
  }

  void _removeResponsibility(int index) {
    setState(() {
      _responsibilitiesList.removeAt(index);
    });
  }

  void _onSave() {
    if (_jobRoleController.text.isEmpty ||
        _companyNameController.text.isEmpty ||
        _startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in required fields")),
      );
      return;
    }

    final newExperience = WorkExperience(
      id: DateTime.now().toString(),
      jobTitle: _jobRoleController.text,
      companyName: _companyNameController.text,
      employmentType: _selectedEmploymentType ?? 'Full-time',
      location: _locationController.text,
      responsibilities: _responsibilitiesList, 
      startDate: _startDate!,
      endDate: _isCurrentlyWorking ? null : _endDate,
      isCurrentlyWorking: _isCurrentlyWorking,
    );

    context.read<ProfileCubit>().addWorkExperience(newExperience);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _jobRoleController.dispose();
    _locationController.dispose();
    _resItemController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    DateTime initial = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now());

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 250.h,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: initial,
                  mode: CupertinoDatePickerMode.monthYear,
                  minimumDate: DateTime(1990),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      if (isStart) {
                        _startDate = newDate;
                      } else {
                        _endDate = newDate;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM yyyy');

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: 0.85.sh,
        width: 1.sw,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Add Work Experience',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Share where you\'ve worked on your profile.',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 20.h),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                children: [
                  _buildLabel("Job Title"),
                  _buildTextField(
                    controller: _jobRoleController,
                    hint: "e.g. Senior Product Designer",
                  ),
                  SizedBox(height: 16.h),

                  _buildLabel("Company"),
                  _buildTextField(
                    controller: _companyNameController,
                    hint: "e.g. Google",
                    icon: Icons.business,
                  ),
                  SizedBox(height: 16.h),

                  _buildLabel("Employment Type"),
                  DropdownButtonFormField<String>(
                    value: _selectedEmploymentType,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: _inputDecoration(hint: "Select type"),
                    items: _employmentTypes.map((String type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedEmploymentType = val),
                  ),
                  SizedBox(height: 16.h),

                  _buildLabel("Location"),
                  _buildTextField(
                    controller: _locationController,
                    hint: "e.g. New York, USA",
                    icon: Icons.location_on_outlined,
                  ),
                  SizedBox(height: 16.h),

                  Row(
                    children: [
                      SizedBox(
                        height: 24.h,
                        width: 24.w,
                        child: Checkbox(
                          value: _isCurrentlyWorking,
                          activeColor: Colors.black87,
                          onChanged: (val) {
                            setState(() {
                              _isCurrentlyWorking = val ?? false;
                              if (_isCurrentlyWorking) _endDate = null;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "I am currently working in this role",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Start Date"),
                            GestureDetector(
                              onTap: () => _pickDate(true),
                              child: _buildDateDisplay(
                                _startDate,
                                dateFormat,
                                "Start Date",
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
                            _buildLabel("End Date"),
                            GestureDetector(
                              onTap: _isCurrentlyWorking
                                  ? null
                                  : () => _pickDate(false),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _isCurrentlyWorking
                                      ? Colors.grey[100]
                                      : null,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: _buildDateDisplay(
                                  _endDate,
                                  dateFormat,
                                  _isCurrentlyWorking ? "Present" : "End Date",
                                  isPlaceholder:
                                      _endDate == null && !_isCurrentlyWorking,
                                  isPresent: _isCurrentlyWorking,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  _buildLabel("Responsibilities"),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _resItemController,
                          hint: "Add a key achievement...",
                          onSubmitted: (_) => _addResponsibility(),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      IconButton(
                        onPressed: _addResponsibility,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  if (_responsibilitiesList.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: _responsibilitiesList.asMap().entries.map((
                          entry,
                        ) {
                          int idx = entry.key;
                          String val = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 6.h),
                                  child: Icon(
                                    Icons.circle,
                                    size: 6.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    val,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _removeResponsibility(idx),
                                  child: Padding(
                                    padding: EdgeInsets.all(4.w),
                                    child: Icon(
                                      Icons.close,
                                      size: 16.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(24.w),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Save Experience",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDisplay(
    DateTime? date,
    DateFormat fmt,
    String placeholder, {
    bool isPlaceholder = false,
    bool isPresent = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isPresent
                ? "Present"
                : (date == null ? placeholder : fmt.format(date)),
            style: TextStyle(
              color: isPresent
                  ? Colors.green
                  : (date == null ? Colors.grey[500] : Colors.black87),
              fontSize: 14.sp,
              fontWeight: isPresent ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (!isPresent)
            Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey[600]),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      style: TextStyle(fontSize: 14.sp),
      decoration: _inputDecoration(hint: hint, icon: icon),
    );
  }

  InputDecoration _inputDecoration({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      prefixIcon: icon != null
          ? Icon(icon, size: 20.sp, color: Colors.grey[500])
          : null,
      filled: true,
      fillColor: Colors.white,
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
}
