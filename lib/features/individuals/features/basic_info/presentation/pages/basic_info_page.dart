import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/individuals/features/basic_info/presentation/cubit/basic_info_cubit.dart';
import 'package:graduation_project/features/individuals/features/basic_info/presentation/widgets/custom_text_field.dart';
import 'package:graduation_project/features/shared/user_cubit.dart';

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
          style: TextStyle(color: Color(0xFF1E293B)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
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

            Navigator.of(context).pop();
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
                hint: 'Software Engineer',
                initialValue: currentUser.jobTitle,
                onChanged: (val) =>
                    context.read<BasicInfoCubit>().jobTitleChanged(val),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Location',
                hint: 'New York, USA',
                initialValue: currentUser.location,
                onChanged: (val) =>
                    context.read<BasicInfoCubit>().locationChanged(val),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Phone',
                hint: '1234567890',
                initialValue: currentUser.phoneNumber,
                onChanged: (val) =>
                    context.read<BasicInfoCubit>().phoneChanged(val),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Email',
                hint: 'email@example.com',
                initialValue: currentUser.email,
                onChanged: (val) =>
                    context.read<BasicInfoCubit>().emailChanged(val),
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
                ),
                child: state.status == FormStatus.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            );
          },
        ),
      ),
    );
  }
}
