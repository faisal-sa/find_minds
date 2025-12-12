import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/individuals/AI_quiz/cubit/ai_skill_check_state.dart';
import 'package:graduation_project/features/individuals/AI_quiz/models/quiz_question.dart';
import 'package:graduation_project/features/individuals/AI_quiz/models/skill_category_result.dart';
import 'package:graduation_project/features/shared/domain/entities/user_entity.dart';
import 'package:graduation_project/main.dart';

class AiSkillCheckCubit extends Cubit<AiSkillCheckState> {


  AiSkillCheckCubit() : super(AiSkillCheckInitial());

  List<QuizQuestion> _currentQuestions = [];

  Future<void> generateQuiz(UserEntity user) async {
    emit(AiSkillCheckLoading());

    try {
      final jobTitle = user.jobTitle.isNotEmpty ? user.jobTitle : "General Professional";
      
      // Construct user context for the AI
      final contextString = user.workExperiences.map((e) {
        return "${e.jobTitle} - ${e.responsibilities}";
      }).join("; ");

      final prompt = '''
        You are an expert technical interviewer. Generate a technical quiz for a "$jobTitle".
        Context from resume: $contextString.
        
        Generate 5 multiple-choice questions. 
        Each question must have a 'category' (e.g., UI/UX, Backend, Leadership, Data Analysis).
        
        Return valid JSON ONLY (no markdown):
        [
          {
            "question": "Question text here?",
            "options": ["Option A", "Option B", "Option C", "Option D"],
            "correctIndex": 0,
            "category": "Specific Skill Category"
          }
        ]
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      final responseText = response.text;
      if (responseText == null) {
        emit(const AiSkillCheckError("Failed to generate quiz."));
        return;
      }

      // Parse JSON
      String jsonString = responseText.replaceAll('```json', '').replaceAll('```', '').trim();
      final List<dynamic> data = jsonDecode(jsonString);

      _currentQuestions = data.map((e) => QuizQuestion.fromMap(e)).toList();

      emit(AiSkillCheckQuestionsLoaded(_currentQuestions));

    } catch (e) {
      emit(AiSkillCheckError("Error generating quiz: ${e.toString()}"));
    }
  }

  // Calculate results based on user answers (indices of selected options)
  void submitQuizAnswers(List<int?> userAnswers) {
    if (_currentQuestions.isEmpty) return;

    int correctCount = 0;
    Map<String, List<bool>> categoryMap = {};

    for (int i = 0; i < _currentQuestions.length; i++) {
      final question = _currentQuestions[i];
      final isCorrect = userAnswers[i] == question.correctIndex;
      
      if (isCorrect) correctCount++;

      if (!categoryMap.containsKey(question.category)) {
        categoryMap[question.category] = [];
      }
      categoryMap[question.category]!.add(isCorrect);
    }

    // Calculate Total Score
    final totalScore = ((correctCount / _currentQuestions.length) * 100).round();

    // Calculate Breakdown
    final breakdown = categoryMap.entries.map((entry) {
      final totalInCat = entry.value.length;
      final correctInCat = entry.value.where((v) => v).length;
      final percentage = ((correctInCat / totalInCat) * 100).round();

      String status;
      if (percentage >= 90) status = "Strong";
      else if (percentage >= 70) status = "Proficient";
      else status = "Needs Improvement";

      return SkillCategoryResult(
        category: entry.key,
        scorePercentage: percentage,
        status: status,
      );
    }).toList();

    emit(AiSkillCheckCompleted(totalScore: totalScore, breakdown: breakdown));
  }
}