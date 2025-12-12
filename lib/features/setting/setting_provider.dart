import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/app_config_repository.dart';
import 'data/setting_repository.dart';

final appConfigRepositoryProvider = AutoDisposeFutureProvider((ref) => AppConfigRepository.instance.init());
final appSettingRepositoryProvider = AutoDisposeFutureProvider((ref) => SettingRepository.instance.init());

final settingRepositoryProvider = Provider<SettingRepository>((ref) {
  return SettingRepository.instance; // declared elsewhere
});
// final settingRepositoryInitProvider = FutureProvider((ref) {
//   debugPrint("settingRepositoryInitProvider");
//   final val = ref.watch(settingRepositoryProvider);
//   debugPrint("settingRepositoryInitProvider after watch");
//   return val.init();
// }
// );
