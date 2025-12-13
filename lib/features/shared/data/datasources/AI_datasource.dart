import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:graduation_project/core/exports/app_exports.dart';
import 'package:graduation_project/features/shared/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';


@injectable
class AIDataSource {
  final GenerativeModel model;

  AIDataSource(this.model);

  Future<UserEntity> extractResume(Uint8List pdfBytes) async {
final promptText = """
      You are a data extraction assistant.
      Analyze the attached resume PDF.
      Extract the following fields and return them in a raw JSON format:
      - firstName
      - lastName
      - email
      - phoneNumber
      - summary (Create a short professional summary if one doesn't exist)

      Rules:
      1. Return ONLY the JSON object. Do not include markdown formatting like ```json ... ```.
      2. If a field is not found, use an empty string "".
      3. Fix any capitalization issues in names.
    """;

    final prompt = TextPart(promptText);

    final pdfPart = InlineDataPart('application/pdf', pdfBytes);

    final response = await model.generateContent([
      Content.multi([prompt, pdfPart]),
    ]);

    final responseText = response.text;
    debugPrint("AI response to Resume upload:\n $responseText");
    if (responseText == null || responseText.isEmpty) {
      throw Exception("AI returned empty response");
    }

    try {
      String cleanJson = responseText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final Map<String, dynamic> data = jsonDecode(cleanJson);

      return UserEntity(
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: data['email'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        summary: data['summary'] ?? '',
      );
    } catch (e) {
      throw Exception("Failed to parse AI JSON: $e");
    }
  }
}