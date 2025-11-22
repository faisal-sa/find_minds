// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/authentication/data/datasources/authentication_remote_data_source.dart'
    as _i308;
import '../../features/authentication/data/repositories/authentication_repository_impl.dart'
    as _i195;
import '../../features/authentication/domain/repositories/authentication_repository.dart'
    as _i1048;
import '../../features/authentication/domain/usecases/get_current_user_usecase.dart'
    as _i455;
import '../../features/authentication/domain/usecases/login_usecase.dart'
    as _i995;
import '../../features/authentication/domain/usecases/signout_usecase.dart'
    as _i14;
import '../../features/authentication/domain/usecases/signup_usecase.dart'
    as _i712;
import '../../features/authentication/presentation/cubit/authentication_cubit.dart'
    as _i675;
import '../env_config/env_config.dart' as _i113;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i454.SupabaseClient>(
      () => registerModule.supabaseClient,
      preResolve: true,
    );
    gh.lazySingleton<_i308.AuthenticationRemoteDataSource>(
      () => _i308.AuthenticationRemoteDataSourceImpl(
        supabaseClient: gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i1048.AuthenticationRepository>(
      () => _i195.AuthenticationRepositoryImpl(
        remoteDataSource: gh<_i308.AuthenticationRemoteDataSource>(),
      ),
    );
    gh.factory<_i455.GetCurrentUserUsecase>(
      () => _i455.GetCurrentUserUsecase(
        repository: gh<_i1048.AuthenticationRepository>(),
      ),
    );
    gh.factory<_i995.LoginUsecase>(
      () =>
          _i995.LoginUsecase(repository: gh<_i1048.AuthenticationRepository>()),
    );
    gh.factory<_i14.SignoutUsecase>(
      () => _i14.SignoutUsecase(
        repository: gh<_i1048.AuthenticationRepository>(),
      ),
    );
    gh.factory<_i712.SignupUsecase>(
      () => _i712.SignupUsecase(
        repository: gh<_i1048.AuthenticationRepository>(),
      ),
    );
    gh.lazySingleton<_i675.AuthenticationCubit>(
      () => _i675.AuthenticationCubit(
        getCurrentUserUsecase: gh<_i455.GetCurrentUserUsecase>(),
        loginUsecase: gh<_i995.LoginUsecase>(),
        signoutUsecase: gh<_i14.SignoutUsecase>(),
        signupUsecase: gh<_i712.SignupUsecase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i113.RegisterModule {}
