import 'package:dartz/dartz.dart';
import 'package:simplemusicplayer/core/common/hive/hive_service/setting_hive_service.dart';
import 'package:simplemusicplayer/core/failure/error_handler.dart';
import 'package:simplemusicplayer/core/usecase/usecase.dart';
import 'package:simplemusicplayer/features/home/domain/entity/song_entity.dart';
import 'package:simplemusicplayer/features/home/domain/repository/audio_query_repository.dart';

class UpdateSongUsecase extends UseCase<String, UpdateParams> {
  final IAudioQueryRepository audioQueryRepository;
  final SettingsHiveService settingsHiveService;

  UpdateSongUsecase({
    required this.audioQueryRepository,
    required this.settingsHiveService,
  });

  @override
  Future<Either<AppErrorHandler, String>> call(UpdateParams params) async {
    try {
      final setting = await settingsHiveService.getSettings();

      if (setting.token == null && !setting.offline) {
        return Left(
          AppErrorHandler(
            message: 'No Token',
            status: false,
          ),
        );
      } else {
        final response = await audioQueryRepository.updateSong(
          song: params.song,
          offline: params.offline,
          token: setting.token ?? '',
        );
        return response;
      }
    } catch (e) {
      return Left(
        AppErrorHandler(
          message: e.toString(),
          status: false,
        ),
      );
    }
  }
}

class UpdateParams {
  final SongEntity song;
  final bool offline;
  UpdateParams({
    required this.song,
    required this.offline,
  });
}
