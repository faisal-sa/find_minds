// lib/features/company_portal/domain/repositories/company_portal_repository.dart
import 'package:multiple_result/multiple_result.dart';
import '../../../../core/error/failures.dart';
import '../../../shared/data/domain/entities/company_entity.dart';

abstract class CompanyRepository {
  Future<Result<CompanyEntity, Failure>> registerCompany({
    required String email,
    required String password,
  });

  Future<Result<CompanyEntity, Failure>> getCompanyProfile(String userId);

  Future<Result<CompanyEntity, Failure>> updateCompanyProfile(
    CompanyEntity company,
  );

  Future<Result<Map<String, bool>, Failure>> checkCompanyStatus(String userId);

  Future<Result<void, Failure>> verifyCompanyQR(String qrCodeData);
}
