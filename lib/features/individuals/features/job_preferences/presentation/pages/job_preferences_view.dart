import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../domain/entities/job_preferences_entity.dart';
import '../cubit/job_preferences_cubit.dart';

class JobPreferencesView extends StatefulWidget {
  const JobPreferencesView({super.key});

  @override
  State<JobPreferencesView> createState() => _JobPreferencesViewState();
}

class _JobPreferencesViewState extends State<JobPreferencesView> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  final TextEditingController _noticePeriodController = TextEditingController();

  // Local State
  List<String> _targetRoles = [];
  List<String> _employmentTypes = [];
  List<String> _workModes = [];
  String? _currentWorkStatus;
  String _salaryCurrency = 'USD';
  bool _canRelocate = false;
  bool _canStartImmediately = false;

  // Constants for Dropdowns/Chips
  final List<String> _availableWorkModes = ['Remote', 'Onsite', 'Hybrid'];
  final List<String> _availableEmpTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Freelance',
    'Co-op',
  ];
  final List<String> _workStatuses = [
    'Open to work',
    'Actively applying',
    'Not looking',
    'Casual browsing',
  ];
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'CAD', 'AUD'];

  @override
  void dispose() {
    _roleController.dispose();
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    _noticePeriodController.dispose();
    super.dispose();
  }

  /// Initialize local state from the loaded entity
  void _initializeValues(JobPreferencesEntity prefs) {
    _targetRoles = List.from(prefs.targetRoles);
    _employmentTypes = List.from(prefs.employmentTypes);
    _workModes = List.from(prefs.workModes);

    _minSalaryController.text = prefs.minSalary?.toString() ?? '';
    _maxSalaryController.text = prefs.maxSalary?.toString() ?? '';
    _salaryCurrency = prefs.salaryCurrency ?? 'USD';

    _currentWorkStatus = prefs.currentWorkStatus;
    _canRelocate = prefs.canRelocate;
    _canStartImmediately = prefs.canStartImmediately;
    _noticePeriodController.text = prefs.noticePeriodDays?.toString() ?? '';
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final entity = JobPreferencesEntity(
        targetRoles: _targetRoles,
        minSalary: int.tryParse(_minSalaryController.text),
        maxSalary: int.tryParse(_maxSalaryController.text),
        salaryCurrency: _salaryCurrency,
        currentWorkStatus: _currentWorkStatus,
        employmentTypes: _employmentTypes,
        workModes: _workModes,
        canRelocate: _canRelocate,
        canStartImmediately: _canStartImmediately,
        noticePeriodDays: int.tryParse(_noticePeriodController.text),
      );

      context.read<JobPreferencesCubit>().savePreferences(entity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JobPreferencesCubit, JobPreferencesState>(
      listener: (context, state) {
        if (state is JobPreferencesSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Preferences saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is JobPreferencesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is JobPreferencesLoaded) {
          // Sync local state when data loads from DB
          setState(() {
            _initializeValues(state.preferences);
          });
        }
      },
      builder: (context, state) {
        if (state is JobPreferencesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Target Roles'),
                _buildRoleInput(),
                const Gap(8),
                Wrap(
                  spacing: 8,
                  children: _targetRoles.map((role) {
                    return Chip(
                      label: Text(role),
                      onDeleted: () {
                        setState(() {
                          _targetRoles.remove(role);
                        });
                      },
                    );
                  }).toList(),
                ),

                const Gap(24),
                _buildSectionHeader('Salary Expectations (Annual)'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _minSalaryController,
                        decoration: const InputDecoration(labelText: 'Min'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: TextFormField(
                        controller: _maxSalaryController,
                        decoration: const InputDecoration(labelText: 'Max'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const Gap(16),
                    DropdownButton<String>(
                      value: _currencies.contains(_salaryCurrency)
                          ? _salaryCurrency
                          : _currencies.first,
                      items: _currencies
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _salaryCurrency = val!),
                    ),
                  ],
                ),

                const Gap(24),
                _buildSectionHeader('Current Work Status'),
                DropdownButtonFormField<String>(
                  initialValue: _currentWorkStatus,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: _workStatuses
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _currentWorkStatus = val),
                ),

                const Gap(24),
                _buildSectionHeader('Work Environment'),
                Wrap(
                  spacing: 8,
                  children: _availableWorkModes.map((mode) {
                    final isSelected = _workModes.contains(mode);
                    return FilterChip(
                      label: Text(mode),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selected
                              ? _workModes.add(mode)
                              : _workModes.remove(mode);
                        });
                      },
                    );
                  }).toList(),
                ),

                const Gap(16),
                _buildSectionHeader('Employment Type'),
                Wrap(
                  spacing: 8,
                  children: _availableEmpTypes.map((type) {
                    final isSelected = _employmentTypes.contains(type);
                    return FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selected
                              ? _employmentTypes.add(type)
                              : _employmentTypes.remove(type);
                        });
                      },
                    );
                  }).toList(),
                ),

                const Gap(24),
                _buildSectionHeader('Availability'),
                SwitchListTile(
                  title: const Text('Open to Relocation'),
                  value: _canRelocate,
                  onChanged: (val) => setState(() => _canRelocate = val),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  title: const Text('Can Start Immediately'),
                  value: _canStartImmediately,
                  onChanged: (val) =>
                      setState(() => _canStartImmediately = val),
                  contentPadding: EdgeInsets.zero,
                ),

                // Only show Notice Period if NOT starting immediately
                if (!_canStartImmediately) ...[
                  const Gap(8),
                  TextFormField(
                    controller: _noticePeriodController,
                    decoration: const InputDecoration(
                      labelText: 'Notice Period (Days)',
                      border: OutlineInputBorder(),
                      helperText: 'How many days before you can join?',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],

                const Gap(32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Save Preferences',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const Gap(24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _roleController,
            decoration: const InputDecoration(
              hintText: 'e.g. Senior Flutter Developer',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: (_) => _addRole(),
          ),
        ),
        const Gap(8),
        IconButton(
          onPressed: _addRole,
          icon: const Icon(Icons.add_circle),
          color: Theme.of(context).primaryColor,
          iconSize: 32,
        ),
      ],
    );
  }

  void _addRole() {
    final text = _roleController.text.trim();
    if (text.isNotEmpty && !_targetRoles.contains(text)) {
      setState(() {
        _targetRoles.add(text);
        _roleController.clear();
      });
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
