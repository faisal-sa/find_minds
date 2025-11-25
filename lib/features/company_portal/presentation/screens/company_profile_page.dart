import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/company_portal/domain/entities/company_entity.dart';
import 'package:graduation_project/features/company_portal/presentation/blocs/bloc/company_bloc.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  final _form = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _industry;
  late TextEditingController _desc;
  late TextEditingController _city;
  late TextEditingController _website;
  late TextEditingController _phone;
  CompanyEntity? _entity;

  @override
  void initState() {
    final state = context.read<CompanyBloc>().state;
    if (state is CompanyLoaded) _entity = state.company;
    _name = TextEditingController(text: _entity?.companyName ?? '');
    _industry = TextEditingController(text: _entity?.industry ?? '');
    _desc = TextEditingController(text: _entity?.description ?? '');
    _city = TextEditingController(text: _entity?.city ?? '');
    _website = TextEditingController(text: _entity?.website ?? '');
    _phone = TextEditingController(text: _entity?.phone ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _industry.dispose();
    _desc.dispose();
    _city.dispose();
    _website.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company Profile')),
      body: BlocConsumer<CompanyBloc, CompanyState>(
        listener: (context, state) {
          if (state is CompanyError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is CompanyLoaded &&
              _entity != null &&
              state.company != _entity) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Profile updated')));
          }
        },
        builder: (context, state) {
          final loading = state is CompanyLoading;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                    ),
                  ),
                  TextFormField(
                    controller: _industry,
                    decoration: const InputDecoration(labelText: 'Industry'),
                  ),
                  TextFormField(
                    controller: _desc,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  TextFormField(
                    controller: _city,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                  TextFormField(
                    controller: _website,
                    decoration: const InputDecoration(labelText: 'Website'),
                  ),
                  TextFormField(
                    controller: _phone,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: loading
                        ? null
                        : () {
                            if (_entity == null) return;
                            final updated = CompanyEntity(
                              id: _entity!.id,
                              userId: _entity!.userId,
                              companyName: _name.text,
                              industry: _industry.text,
                              description: _desc.text,
                              city: _city.text,
                              address: _entity!.address,
                              companySize: _entity!.companySize,
                              website: _website.text,
                              email: _entity!.email,
                              phone: _phone.text,
                              logoUrl: _entity!.logoUrl,
                              createdAt: _entity!.createdAt,
                              updatedAt: DateTime.now(),
                            );
                            context.read<CompanyBloc>().add(
                              UpdateCompanyProfileEvent(updated),
                            );
                          },

                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
