import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/features/ai_analysis/domain/repositories/ai_analysis_repository.dart';
import 'package:graduation_project/features/ai_analysis/presentation/cubit/ai_analysis_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class AiAnalysisCubit extends Cubit<AiAnalysisState> {
  final AiRepository _repository;

  AiAnalysisCubit(this._repository) : super(AiInitial());

  Future<void> analyzeProfile({
    required String candidateName,
    required String skills,
    required String jobTitle,
    required String targetJobTitle,
  }) async {
    emit(AiLoading());

    final candidateData = {
      'name': candidateName,
      'skills': skills,
      'current_title': jobTitle,
    };

    final jobReqs = {'target_title': targetJobTitle};

    final result = await _repository.getAnalysis(
      candidateData: candidateData,
      jobRequirements: jobReqs,
    );

    result.when(
      (data) => emit(AiLoaded(data)),
      (error) => emit(AiError(error.message)),
    );
  }
}
