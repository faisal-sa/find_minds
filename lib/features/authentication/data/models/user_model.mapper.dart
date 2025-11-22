// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_model.dart';

class UserModelMapper extends ClassMapperBase<UserModel> {
  UserModelMapper._();

  static UserModelMapper? _instance;
  static UserModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserModel';

  static String _$fullName(UserModel v) => v.fullName;
  static const Field<UserModel, String> _f$fullName = Field(
    'fullName',
    _$fullName,
  );
  static String _$email(UserModel v) => v.email;
  static const Field<UserModel, String> _f$email = Field('email', _$email);
  static bool _$isEmailVerified(UserModel v) => v.isEmailVerified;
  static const Field<UserModel, bool> _f$isEmailVerified = Field(
    'isEmailVerified',
    _$isEmailVerified,
  );
  static String? _$token(UserModel v) => v.token;
  static const Field<UserModel, String> _f$token = Field(
    'token',
    _$token,
    opt: true,
  );

  @override
  final MappableFields<UserModel> fields = const {
    #fullName: _f$fullName,
    #email: _f$email,
    #isEmailVerified: _f$isEmailVerified,
    #token: _f$token,
  };

  static UserModel _instantiate(DecodingData data) {
    return UserModel(
      fullName: data.dec(_f$fullName),
      email: data.dec(_f$email),
      isEmailVerified: data.dec(_f$isEmailVerified),
      token: data.dec(_f$token),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserModel>(map);
  }

  static UserModel fromJson(String json) {
    return ensureInitialized().decodeJson<UserModel>(json);
  }
}

mixin UserModelMappable {
  String toJson() {
    return UserModelMapper.ensureInitialized().encodeJson<UserModel>(
      this as UserModel,
    );
  }

  Map<String, dynamic> toMap() {
    return UserModelMapper.ensureInitialized().encodeMap<UserModel>(
      this as UserModel,
    );
  }

  UserModelCopyWith<UserModel, UserModel, UserModel> get copyWith =>
      _UserModelCopyWithImpl<UserModel, UserModel>(
        this as UserModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserModelMapper.ensureInitialized().stringifyValue(
      this as UserModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserModelMapper.ensureInitialized().equalsValue(
      this as UserModel,
      other,
    );
  }

  @override
  int get hashCode {
    return UserModelMapper.ensureInitialized().hashValue(this as UserModel);
  }
}

extension UserModelValueCopy<$R, $Out> on ObjectCopyWith<$R, UserModel, $Out> {
  UserModelCopyWith<$R, UserModel, $Out> get $asUserModel =>
      $base.as((v, t, t2) => _UserModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserModelCopyWith<$R, $In extends UserModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? fullName,
    String? email,
    bool? isEmailVerified,
    String? token,
  });
  UserModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserModel, $Out>
    implements UserModelCopyWith<$R, UserModel, $Out> {
  _UserModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserModel> $mapper =
      UserModelMapper.ensureInitialized();
  @override
  $R call({
    String? fullName,
    String? email,
    bool? isEmailVerified,
    Object? token = $none,
  }) => $apply(
    FieldCopyWithData({
      if (fullName != null) #fullName: fullName,
      if (email != null) #email: email,
      if (isEmailVerified != null) #isEmailVerified: isEmailVerified,
      if (token != $none) #token: token,
    }),
  );
  @override
  UserModel $make(CopyWithData data) => UserModel(
    fullName: data.get(#fullName, or: $value.fullName),
    email: data.get(#email, or: $value.email),
    isEmailVerified: data.get(#isEmailVerified, or: $value.isEmailVerified),
    token: data.get(#token, or: $value.token),
  );

  @override
  UserModelCopyWith<$R2, UserModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

