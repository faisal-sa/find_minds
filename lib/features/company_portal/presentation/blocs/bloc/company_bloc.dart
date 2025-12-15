// lib/features/company_portal/presentation/bloc/company_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/shared/data/domain/entities/candidate_entity.dart';
import 'package:graduation_project/features/shared/data/domain/entities/company_entity.dart';
import 'package:graduation_project/features/company_portal/domain/usecases/check_company_status.dart';
import 'package:graduation_project/features/company_portal/domain/usecases/get_company_profile.dart';
import 'package:graduation_project/features/company_portal/domain/usecases/register_company.dart';
import 'package:graduation_project/features/company_portal/domain/usecases/update_company_profile.dart';
import 'package:graduation_project/features/company_portal/domain/usecases/verify_company_qr.dart';
import 'package:injectable/injectable.dart';

part 'company_event.dart';
part 'company_state.dart';

@injectable
class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final GetCompanyProfile _getCompanyProfile;
  final UpdateCompanyProfile _updateCompanyProfile;
  final CheckCompanyStatus _checkCompanyStatus;
  final RegisterCompany _registerCompany;
  final VerifyCompanyQR _verifyCompanyQR;

  CompanyBloc(
    this._getCompanyProfile,
    this._updateCompanyProfile,
    this._checkCompanyStatus,
    this._registerCompany,
    this._verifyCompanyQR,
  ) : super(const CompanyInitial()) {
    on<GetCompanyProfileEvent>(_onGetCompanyProfile);
    on<UpdateCompanyProfileEvent>(_onUpdateCompanyProfile);
    on<CheckCompanyStatusEvent>(_onCheckCompanyStatus);
    on<RegisterCompanyEvent>(_onRegisterCompany);
    on<VerifyCompanyQREvent>(_onVerifyCompanyQR);
  }

  Future<void> _onRegisterCompany(
    RegisterCompanyEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(const CompanyLoading());
    final result = await _registerCompany(
      email: event.email,
      password: event.password,
    );
    result.when(
      (company) => emit(CompanyLoaded(company)),
      (failure) => emit(CompanyError(failure.message)),
    );
  }

  Future<void> _onGetCompanyProfile(
    GetCompanyProfileEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(const CompanyLoading());
    final result = await _getCompanyProfile(event.userId);
    result.when(
      (company) => emit(CompanyLoaded(company)),
      (failure) => emit(CompanyError(failure.message)),
    );
  }

  Future<void> _onUpdateCompanyProfile(
    UpdateCompanyProfileEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(const CompanyLoading());
    final result = await _updateCompanyProfile(event.company);

    result.when(
      (company) => emit(CompanyLoaded(company)),
      (failure) => emit(CompanyError(failure.message)),
    );
  }

  Future<void> _onCheckCompanyStatus(
    CheckCompanyStatusEvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(const CompanyLoading());
    final result = await _checkCompanyStatus(event.userId);

    result.when(
      (status) => emit(
        CompanyStatusChecked(
          hasProfile: status['hasProfile']!,
          hasPaid: status['hasPaid']!,
        ),
      ),
      (failure) => emit(CompanyError(failure.message)),
    );
  }

  Future<void> _onVerifyCompanyQR(
    VerifyCompanyQREvent event,
    Emitter<CompanyState> emit,
  ) async {
    emit(const CompanyLoading());
    final result = await _verifyCompanyQR(event.qrCodeData);

    result.when(
      (_) => emit(const QRVerificationSuccess()),
      (failure) => emit(CompanyError(failure.message)),
    );
  }
}
