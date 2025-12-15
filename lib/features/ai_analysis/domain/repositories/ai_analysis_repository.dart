import 'package:multiple_result/multiple_result.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/ai_score_model.dart';

abstract class AiRepository {
  Future<Result<AiScoreModel, Failure>> getAnalysis({
    required Map<String, dynamic> candidateData,
    required Map<String, dynamic> jobRequirements,
  });
}
