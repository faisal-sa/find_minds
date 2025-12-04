import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/core/di/service_locator.dart';
import 'package:graduation_project/features/company_portal/presentation/blocs/bloc/company_bloc.dart';
import 'package:graduation_project/features/company_portal/domain/entities/company_entity.dart';
import 'package:graduation_project/core/storage/company_local_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ✅ Change to StatefulWidget
class CompleteCompanyProfilePage extends StatefulWidget {
  const CompleteCompanyProfilePage({super.key});

  @override
  State<CompleteCompanyProfilePage> createState() =>
      _CompleteCompanyProfilePageState();
}

class _CompleteCompanyProfilePageState
    extends State<CompleteCompanyProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // ✅ Define Controllers here (State keeps them alive)
  late TextEditingController nameController;
  late TextEditingController industryController;
  late TextEditingController cityController;
  late TextEditingController descController;
  late TextEditingController websiteController;
  late TextEditingController addressController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  String? selectedSize;

  final sizeOptions = [
    '1-50 employees',
    '51-200 employees',
    '201-1000 employees',
    '1000+ employees',
  ];

  @override
  void initState() {
    super.initState();
    // ✅ Initialize Controllers once
    // Removed "a" text for production readiness
    nameController = TextEditingController();
    industryController = TextEditingController();
    cityController = TextEditingController();
    descController = TextEditingController();
    websiteController = TextEditingController();
    addressController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    // ✅ Dispose to prevent memory leaks
    nameController.dispose();
    industryController.dispose();
    cityController.dispose();
    descController.dispose();
    websiteController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Widget _buildVerticalSpace({double height = 16.0}) =>
      SizedBox(height: height);

  Widget _buildHeader(String title, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        title + (isRequired ? ' *' : ''),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  void _saveProfile(CompanyEntity company) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updated = company.copyWith(
        companyName: nameController.text.trim(),
        industry: industryController.text.trim(),
        city: cityController.text.trim(),
        description: descController.text.trim(),
        website: websiteController.text.trim(),
        address: addressController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        companySize: selectedSize ?? company.companySize,
        updatedAt: DateTime.now(),
      );

      context.read<CompanyBloc>().add(
        UpdateCompanyProfileEvent(company: updated),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Company Profile'),
        // Using safe fallback for colors if theme is null
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<CompanyBloc, CompanyState>(
        listener: (context, state) async {
          if (state is CompanyLoaded) {
            // ✅ Save ID locally for future use
            final userId = serviceLocator
                .get<SupabaseClient>()
                .auth
                .currentUser
                ?.id;
            if (userId != null) {
              await CompanyLocalStorage.saveCompanyId(userId);
            }

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile saved successfully!')),
              );
              // ✅ Navigate to Payment
              context.go('/company/payment');
            }
          } else if (state is CompanyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text('Error: ${state.message}'),
              ),
            );
          }
        },
        builder: (context, state) {
          // Use current company data if available, or create a skeleton
          final company = (state is CompanyLoaded)
              ? state.company
              : CompanyEntity(
                  companyName: '',
                  industry: '',
                  description: '',
                  city: '',
                  logoUrl: "",
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

          // Note: If you want to PRE-FILL data from the DB, you should do it
          // inside `initState` or a `BlocListener`, not here in `build`,
          // otherwise you will overwrite what the user is typing.

          return SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  const Text(
                    'Step 1: Core Company Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _buildVerticalSpace(height: 20),

                  _buildHeader('Company Name', isRequired: true),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g., Acme Corporation',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Company name is required' : null,
                  ),
                  _buildVerticalSpace(),

                  _buildHeader('Industry', isRequired: true),
                  TextFormField(
                    controller: industryController,
                    decoration: const InputDecoration(
                      hintText: 'e.g., Software Development, Finance',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Industry is required' : null,
                  ),
                  _buildVerticalSpace(),

                  _buildHeader('City', isRequired: true),
                  TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      hintText: 'e.g., New York, London',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v!.isEmpty ? 'City is required' : null,
                  ),
                  _buildVerticalSpace(),

                  _buildHeader('Company Size'),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select Company Size',
                    ),
                    value: selectedSize, // Use the state variable
                    items: sizeOptions
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        selectedSize = v;
                      });
                    },
                    onSaved: (v) => selectedSize = v,
                  ),
                  _buildVerticalSpace(),

                  _buildHeader('Description', isRequired: true),
                  TextFormField(
                    controller: descController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Tell us about your company...',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Description is required' : null,
                  ),
                  _buildVerticalSpace(height: 30),

                  const Text(
                    'Step 2: Contact Details (Optional)',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _buildVerticalSpace(height: 20),

                  _buildHeader('Website'),
                  TextFormField(
                    controller: websiteController,
                    decoration: const InputDecoration(
                      hintText: 'https://example.com',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  _buildVerticalSpace(),

                  _buildHeader('Address'),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      hintText: 'Company physical address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  _buildVerticalSpace(),

                  _buildHeader('Email'),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'contact@example.com',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildVerticalSpace(),

                  _buildHeader('Phone'),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: '+1 555 123 4567',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  _buildVerticalSpace(height: 40),

                  Center(
                    child: ElevatedButton(
                      onPressed: state is CompanyLoading
                          ? null // Disable button while loading
                          : () => _saveProfile(company),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: state is CompanyLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'Save and Continue',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  _buildVerticalSpace(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
