import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/features/profile/presentation/widgets/custom_text_field.dart';
import 'package:graduation_project/features/profile/presentation/widgets/segmented_progress_bar.dart';

class ProfilePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text("Make your Profile"),
        centerTitle: true,
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),

        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: .all(16),
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .start,
                  children: [
                    SegmentedProgressBar(),
                    SizedBox(height: 20.h),
                    Text(
                      "Let's start with the\n Basics",
                      style: TextStyle(fontSize: 32.r, fontWeight: .bold),
                    ),
                    Text(
                      "This information will be visiable to recruiters.",
                      style: TextStyle(
                        fontSize: 16.r,
                        color: Color(0xff7b8594),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Row(
                      crossAxisAlignment: .center,
                      children: [
                        InkWell(
                          onTap: () => {},
                          borderRadius: BorderRadius.circular(50),
                          child: DottedBorder(
                            options: CircularDottedBorderOptions(
                              dashPattern: [5, 5],
                              strokeWidth: 2,
                              color: Color(0xffccd6e1),
                            ),
                            child: Container(
                              width: 70.w,
                              height: 70.h,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xfff1f5f9),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  colorFilter: ColorFilter.mode(
                                    Color(0xff67768d),
                                    .srcIn,
                                  ),
                                  "assets/icons/camera_add.svg",
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 25.w),
                        Column(
                          children: [
                            Text(
                              "Upload Photo",
                              style: TextStyle(
                                fontSize: 18.r,
                                fontWeight: .bold,
                              ),
                            ),
                            Text(
                              "Max file size: 5MB",
                              style: TextStyle(
                                fontSize: 14.r,
                                color: Color(0xff7b8594),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    CustomTextField(
                      controller: nameController,
                      title: "Full Name",
                      hint: "Enter your full name",
                    ),
                    CustomTextField(
                      controller: nameController,
                      title: "Location",
                      hint: "e.g., Riyadh, SA",
                    ),
                    CustomTextField(
                      controller: nameController,
                      title: "Email Address",
                      hint: "Enter your email",
                    ),
                    CustomTextField(
                      controller: nameController,
                      title: "Phone Number",
                      hint: "(123) 456-7890",
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(1.sw, 40.h),
                        backgroundColor: Color(0xff135bec),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Continue to Experience",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
