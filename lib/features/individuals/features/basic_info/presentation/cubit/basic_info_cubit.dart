import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation_project/features/individuals/features/basic_info/domain/entities/basic_info_entity.dart';
import 'package:graduation_project/features/individuals/features/basic_info/domain/usecases/save_basic_info_usecase.dart';
import 'package:graduation_project/features/shared/user_entity.dart';
import 'package:injectable/injectable.dart';

part 'basic_info_state.dart';

@injectable
class BasicInfoCubit extends Cubit<BasicInfoState> {
  final SaveBasicInfoUseCase _saveBasicInfoUseCase;

  BasicInfoCubit(this._saveBasicInfoUseCase) : super(const BasicInfoState());

  void initialize(UserEntity user) {
    emit(
      state.copyWith(
        firstName: user.firstName,
        lastName: user.lastName,
        jobTitle: user.jobTitle,
        phoneNumber: user.phoneNumber,
        email: user.email,
        location: user.location,
      ),
    );
  }

  void firstNameChanged(String value) => emit(state.copyWith(firstName: value));
  void lastNameChanged(String value) => emit(state.copyWith(lastName: value));
  void jobTitleChanged(String value) => emit(state.copyWith(jobTitle: value));
  void phoneChanged(String value) => emit(state.copyWith(phoneNumber: value));
  void emailChanged(String value) => emit(state.copyWith(email: value));
  void locationChanged(String value) => emit(state.copyWith(location: value));

  Future<void> saveForm() async {
    if (state.status == FormStatus.loading) return;
    emit(state.copyWith(status: FormStatus.loading));

    try {
      final entity = BasicInfoEntity(
        firstName: state.firstName,
        lastName: state.lastName,
        jobTitle: state.jobTitle,
        phoneNumber: state.phoneNumber,
        email: state.email,
        location: state.location,
      );

      await _saveBasicInfoUseCase(entity);

      emit(state.copyWith(status: FormStatus.success));
    } catch (e) {
      emit(state.copyWith(status: FormStatus.failure));
    }
  }
}
