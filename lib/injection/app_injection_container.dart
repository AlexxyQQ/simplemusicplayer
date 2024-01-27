import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:simplemusicplayer/core/common/hive/hive_service/setting_hive_service.dart';
import 'package:simplemusicplayer/features/library/injection_container/library_injection_container.dart';
import 'package:simplemusicplayer/features/now_playing/injection_container/now_playing_injection_container.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../features/home/injection/home_injection_container.dart';
import '../features/splash/injection/splash_injection_container.dart';

final get = GetIt.instance;

void setupDependencyInjection() {
  NowPlayingInjectionContainer().register();
  LibraryInjectionContainer().register();
  SplashInjectionContainer().register();
  HomeInjectionContainer().register();

  // GetIt.instance.registerLazySingleton(() => HiveQueries());
  GetIt.instance.registerLazySingleton(() => OnAudioQuery());
  GetIt.instance.registerLazySingleton(() => AudioPlayer());
  GetIt.instance.registerLazySingleton(() => SettingsHiveService());
}
