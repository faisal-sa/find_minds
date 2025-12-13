import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final String? label; // Added from Code A
  final IconData? icon;
  final Function(String)? onChanged;
  final String? Function(String?)?
  validator; // Added for Code A compatibility (Forms)
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool isPassword; // Common requirement, implied by generic usage

  const CustomTextField({
    super.key,
    this.hint = '',
    this.label,
    this.icon,
    this.onChanged,
    this.validator,
    this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Logic from Code A: Render label if it exists
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 14.sp, // Adapted to ScreenUtil
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B), // Color from Code A
            ),
          ),
          SizedBox(height: 8.h),
        ],

        // 2. Switched to TextFormField for broader compatibility (Code A legacy)
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          obscureText: isPassword,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF334155), // Text color from Code A
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
            prefixIcon: icon != null
                ? Icon(icon, size: 20.sp, color: Colors.grey[500])
                : null,
            filled: true,
            fillColor: Colors.white,
            // Uses ScreenUtil for padding/radius (from Code B)
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
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
              // You can choose Code A's Blue (0xFF3B82F6) or Code B's Black here. 
              // I kept Code B's black style, but increased width to 1.5 to match A.
              borderSide: const BorderSide(color: Colors.black87, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
