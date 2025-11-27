import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/di/service_locator.dart';
import 'package:graduation_project/features/individuals/features/job_preferences/presentation/cubit/job_preferences_cubit.dart';
import 'package:graduation_project/features/individuals/features/job_preferences/presentation/pages/job_preferences_view.dart';

class JobPreferencesPage extends StatelessWidget {
  const JobPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Preferences')),
      body: BlocProvider(
        create: (context) =>
            serviceLocator<JobPreferencesCubit>()..loadPreferences(),
        child: const JobPreferencesView(),
      ),
    );
  }
}
