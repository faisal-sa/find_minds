part of 'company_bloc.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();
  @override
  List<Object?> get props => [];
}

class GetCompanyProfileEvent extends CompanyEvent {
  final String userId;
  const GetCompanyProfileEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class RegisterCompanyEvent extends CompanyEvent {
  final String email;
  final String password;
  const RegisterCompanyEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class UpdateCompanyProfileEvent extends CompanyEvent {
  final CompanyEntity company;

  const UpdateCompanyProfileEvent({required this.company});

  @override
  List<Object> get props => [company];
}

class CheckCompanyStatusEvent extends CompanyEvent {
  final String userId;
  const CheckCompanyStatusEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class VerifyCompanyQREvent extends CompanyEvent {
  final String qrCodeData;
  const VerifyCompanyQREvent(this.qrCodeData);
  @override
  List<Object?> get props => [qrCodeData];
}
