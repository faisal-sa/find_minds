
import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/individuals/match_strength/cubit/match_strength_state.dart';
import 'package:graduation_project/features/shared/domain/entities/user_entity.dart';
import 'package:graduation_project/main.dart';

class MatchStrengthCubit extends Cubit<MatchStrengthState> {

  MatchStrengthCubit() : super(MatchStrengthInitial());

  

  Future<void> analyzeProfile(UserEntity userEntity) async {
    emit(MatchStrengthLoading());

    try {
      final jobTitle = userEntity.jobTitle.isNotEmpty ? userEntity.jobTitle : "General Role";
      
      final experienceString = userEntity.workExperiences.map((e) {
        return "Role: ${e.jobTitle} at ${e.companyName}. Description: ${e.responsibilities}";
      }).join("\n");

      final educationString = userEntity.educations.map((e) {
        return "Degree: ${e.fieldOfStudy} at ${e.institutionName}";
      }).join("\n");

      // 2. Construct Prompt
      final prompt = '''
        You are a Career ATS AI. Analyze this candidate for the target role: "$jobTitle".
        
        Candidate Data:
        Summary: ${userEntity.summary}
        Experience: $experienceString
        Education: $educationString
        
        Return a valid JSON object with NO markdown formatting.
        Structure:
        {
          "score": (integer 0-100),
          "strengths": ["list of 3 key strengths based on data"],
          "improvements": [
            {
              "issue": "Brief description of missing skill or gap",
              "action": "Short recommendation (e.g., 'View relevant courses' or 'Explore learning paths')"
            },
             {
              "issue": "Brief description of another gap",
              "action": "Short recommendation"
            }
          ]
        }
      ''';

      // 3. Call AI
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      final responseText = response.text;
      if (responseText == null) {
        emit(const MatchStrengthError("Could not generate analysis."));
        return;
      }

      // 4. Parse JSON (Handle potential markdown wrappers)
      String jsonString = responseText.replaceAll('```json', '').replaceAll('```', '').trim();
      final data = jsonDecode(jsonString);

      emit(MatchStrengthLoaded(
        score: data['score'] as int,
        strengths: List<String>.from(data['strengths'] ?? []),
        improvements: List<Map<String, String>>.from(
          (data['improvements'] as List).map((item) => {
            'issue': item['issue'].toString(),
            'action': item['action'].toString(),
          })
        ),
      ));

    } catch (e) {
      emit(MatchStrengthError("Analysis failed: ${e.toString()}"));
    }
  }
}