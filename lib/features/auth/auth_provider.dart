import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'data/auth_local_data_source.dart';
import '../../common/provider/sensing/sensing_api.dart';
import 'data/auth_repository.dart';
import 'domain/auth_repository_interface.dart';

// @Riverpod(keepAlive: true)
// AuthRepositoryInterface authRepository(AuthRepositoryRef ref) {
//   final auth = AuthRepository(SensingApi.instance);
//   //ref.onDispose(() {auth.dispose();});
//   return auth;
// }

final authRepositoryProvider = AutoDisposeProvider<AuthRepositoryInterface>((ref) {
  return AuthRepository(AuthLocalDataSource(), SensingApi.instance);
});


final authStateProvider = StateProvider<bool>((ref) => false);