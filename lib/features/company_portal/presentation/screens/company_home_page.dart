import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompanyHomePage extends StatelessWidget {
  const CompanyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _homeButton(context, 'My Profile', '/company/profile'),
            const SizedBox(height: 12),
            _homeButton(context, 'Search Candidates', '/company/search'),
            const SizedBox(height: 12),
            _homeButton(context, 'Bookmarks', '/company/bookmarks'),
            const SizedBox(height: 12),
            _homeButton(context, 'Scan Candidate QR', '/company/scan'),
          ],
        ),
      ),
    );
  }

  Widget _homeButton(BuildContext context, String label, String route) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => context.go(route),
        child: Text(label),
      ),
    );
  }
}
