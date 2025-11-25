part of 'basic_information_cubit.dart';

@immutable
class BasicInformationState extends Equatable {
  final File? image;

  const BasicInformationState({this.image});

  BasicInformationState copyWith({File? image}) {
    return BasicInformationState(image: image ?? this.image);
  }

  @override
  List<Object?> get props => [image];
}
