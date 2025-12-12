import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/individuals/AI_quiz/cubit/ai_skill_check_cubit.dart';
import 'package:graduation_project/features/individuals/AI_quiz/cubit/ai_skill_check_state.dart';
import 'package:graduation_project/features/individuals/AI_quiz/pages/quiz_view.dart';
import 'package:graduation_project/features/individuals/AI_quiz/pages/result_view.dart';
import 'package:graduation_project/features/shared/domain/entities/user_entity.dart';

class AiSkillCheckPage extends StatelessWidget {
  final UserEntity user;

  const AiSkillCheckPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Inject Cubit here assuming 'model' is available in serviceLocator or similar
    return BlocProvider(
      create: (context) => AiSkillCheckCubit(
      )..generateQuiz(user),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "AI Skill Check",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            )
          ],
        ),
        body: BlocBuilder<AiSkillCheckCubit, AiSkillCheckState>(
          builder: (context, state) {
            if (state is AiSkillCheckLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AiSkillCheckError) {
              return Center(child: Text(state.message));
            } else if (state is AiSkillCheckQuestionsLoaded) {
              return QuizView(questions: state.questions);
            } else if (state is AiSkillCheckCompleted) {
              return ResultView(
                score: state.totalScore,
                breakdown: state.breakdown,
                onRetake: () {
                   context.read<AiSkillCheckCubit>().generateQuiz(user);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}