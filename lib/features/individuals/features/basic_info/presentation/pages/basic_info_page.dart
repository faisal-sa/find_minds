import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/individuals/features/basic_info/presentation/cubit/basic_info_cubit.dart';
import 'package:graduation_project/features/individuals/features/basic_info/presentation/widgets/custom_text_field.dart';
import 'package:graduation_project/features/shared/user_state.dart';

class BasicInfoPage extends StatelessWidget {
  const BasicInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserCubit>().state.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Basic Information',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocListener<BasicInfoCubit, BasicInfoState>(
        listener: (context, state) {
          if (state.status == FormStatus.success) {
            final updatedUser = currentUser.copyWith(
              firstName: state.firstName,
              lastName: state.lastName,
              jobTitle: state.jobTitle,
              phoneNumber: state.phoneNumber,
              email: state.email,
              location: state.location,
            );

            context.read<UserCubit>().updateUser(updatedUser);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile Saved!'),
                backgroundColor: Colors.green,
              ),
            );

            // Optional: Pop back to profile
            // Navigator.of(context).pop();
          } else if (state.status == FormStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to save'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'First Name',
                      hint: 'John',
                      initialValue: currentUser.firstName,
                      onChanged: (val) =>
                          context.read<BasicInfoCubit>().firstNameChanged(val),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Last Name',
                      hint: 'Doe',
                      initialValue: currentUser.lastName,
                      onChanged: (val) =>
                          context.read<BasicInfoCubit>().lastNameChanged(val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              CustomTextField(
                label: 'Job Title',
                hint: 'e.g. Software Engineer',
                initialValue: currentUser.jobTitle,
                onChanged: (val) =>
                    context.read<BasicInfoCubit>().jobTitleChanged(val),
              ),
              const SizedBox(height: 24),

              CustomTextField(
                label: 'Phone Number',
                hint: '(123) 456-7890',
                keyboardType: TextInputType.phone,
                initialValue: currentUser.phoneNumber,
                onChanged: (val) =>
                    context.read<BasicInfoCubit>().phoneChanged(val),
              ),
              const SizedBox(height: 24),

              CustomTextField(
                label: 'Email',
                hint: 'john.doe@email.com',
                keyboardType: TextInputType.emailAddress,
                initialValue: currentUser.email,
                onChanged: (val) =>
                    context.read<BasicInfoCubit>().emailChanged(val),
              ),
              const SizedBox(height: 24),

              CustomTextField(
                label: 'Location',
                hint: 'e.g. San Francisco, CA',
                initialValue: currentUser.location,
                onChanged: (val) =>
                    context.read<BasicInfoCubit>().locationChanged(val),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocBuilder<BasicInfoCubit, BasicInfoState>(
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: state.status == FormStatus.loading
                    ? null
                    : () => context.read<BasicInfoCubit>().saveForm(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: state.status == FormStatus.loading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
