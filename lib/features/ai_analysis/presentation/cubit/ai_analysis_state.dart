// States
import 'package:graduation_project/features/ai_analysis/data/models/ai_score_model.dart';

abstract class AiAnalysisState {}

class AiInitial extends AiAnalysisState {}

class AiLoading extends AiAnalysisState {}

class AiLoaded extends AiAnalysisState {
  final AiScoreModel data;
  AiLoaded(this.data);
}

class AiError extends AiAnalysisState {
  final String message;
  AiError(this.message);
}
