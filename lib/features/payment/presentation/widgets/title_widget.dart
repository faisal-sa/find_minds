import 'package:flutter/material.dart';

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12, top: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        // Changed from Colors.white to Black87 so it is visible on the white page
        color: Colors.black87,
        letterSpacing: 0.3,
      ),
    ),
  );
}
