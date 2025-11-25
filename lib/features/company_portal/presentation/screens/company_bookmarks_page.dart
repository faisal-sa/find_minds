import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CompanyBookmarksPage extends StatefulWidget {
  const CompanyBookmarksPage({super.key});

  @override
  State<CompanyBookmarksPage> createState() => _CompanyBookmarksPageState();
}

class _CompanyBookmarksPageState extends State<CompanyBookmarksPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> data = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final response = await supabase
        .from('company_bookmarks')
        .select('candidate_id, profiles(full_name,skills,city)')
        .eq('company_id', user.id);
    setState(() {
      data = List<Map<String, dynamic>>.from(response);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarked Candidates')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
          ? const Center(child: Text('No bookmarks yet'))
          : ListView.separated(
              itemCount: data.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) {
                final candidate = data[i]['profiles'];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(candidate['full_name'] ?? ''),
                  subtitle: Text(
                    'Skills: ${candidate['skills'] ?? ''}\nCity: ${candidate['city'] ?? ''}',
                  ),
                );
              },
            ),
    );
  }
}
