import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        SizedBox(height: 20.h),

        Text(
          title,
          style: TextStyle(fontSize: 14.r, fontWeight: .w500),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hint: Text(
              hint,
              style: TextStyle(color: Color(0xff94a3b8), fontWeight: .w500),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: .circular(12.r),
              borderSide: BorderSide(color: Color(0xffcbd5e1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: .circular(12.r),
              borderSide: BorderSide(color: Color(0xffcbd5e1), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
