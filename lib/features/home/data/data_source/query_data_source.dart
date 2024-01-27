import 'package:dartz/dartz.dart';
import 'package:simplemusicplayer/features/home/data/data_source/local_data_source/local_data_source.dart';

import '../../../../core/failure/error_handler.dart';
import '../model/app_album_model.dart';
import '../model/app_artist_model.dart';
import '../model/app_folder_model.dart';
import '../model/app_song_model.dart';
import 'local_data_source/hive_service/query_hive_service.dart';

abstract class IAudioQueryDataSource {
  // Songs
  Future<Either<AppErrorHandler, List<AppSongModel>>> getAllSongs({
    required Function(int) onProgress,
    bool? first,
    bool? refetch,
    required String token,
  });

  Future<Either<AppErrorHandler, String>> updateSong({
    required AppSongModel song,
    required String token,
    required bool offline,
  });

  Future<Either<AppErrorHandler, String>> addSong({
    required AppSongModel song,
    required String token,
  });

  Future<Either<AppErrorHandler, String>> addSongs({
    required List<AppSongModel> songs,
    required String token,
  });

  //

  Future<Either<AppErrorHandler, List<AppAlbumModel>>> getAllAlbums({
    bool? refetch,
    required String token,
  });

  Future<Either<AppErrorHandler, List<AppArtistModel>>> getAllArtists({
    bool? refetch,
    required String token,
  });
}

class AudioQueryDataSourceImpl implements IAudioQueryDataSource {
  final AudioQueryLocalDataSource localDataSource;
  final QueryHiveService queryHiveService;

  AudioQueryDataSourceImpl({
    required this.localDataSource,
    required this.queryHiveService,
  });

  // Songs
  @override
  Future<Either<AppErrorHandler, List<AppSongModel>>> getAllSongs({
    required Function(int p1) onProgress,
    bool? first,
    bool? refetch,
    required String token,
  }) async {
    try {
      if (refetch == true) {
        // else return data from the local storage
        return localDataSource.getAllSongs(
          onProgress: onProgress,
          first: first,
          refetch: refetch,
          token: token,
        );
      } else {
        final hiveSongs = await queryHiveService.getAllSongs();
        if (hiveSongs.isNotEmpty) {
          return Right(
            AppSongModel.fromListHiveModel(
              hiveSongs,
            ),
          );
        } else {
          return Left(
            AppErrorHandler(
              message: 'No songs found',
              status: false,
            ),
          );
        }
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

  @override
  Future<Either<AppErrorHandler, String>> addSong({
    required AppSongModel song,
    required String token,
  }) async {
    try {
      return localDataSource.addSong(
        song: song,
        token: token,
      );
    } catch (e) {
      return Left(
        AppErrorHandler(
          message: e.toString(),
          status: false,
        ),
      );
    }
  }

  @override
  Future<Either<AppErrorHandler, String>> addSongs({
    required List<AppSongModel> songs,
    required String token,
  }) async {
    try {
      // else return data from the local storage
      return localDataSource.addSongs(
        songs: songs,
        token: token,
      );
    } catch (e) {
      return Left(
        AppErrorHandler(
          message: e.toString(),
          status: false,
        ),
      );
    }
  }

  @override
  Future<Either<AppErrorHandler, String>> updateSong({
    required AppSongModel song,
    required String token,
    required bool offline,
  }) async {
    try {
      return localDataSource.updateSong(
        song: song,
        token: token,
        offline: offline,
      );
    } catch (e) {
      return Left(
        AppErrorHandler(
          message: e.toString(),
          status: false,
        ),
      );
    }
  }

  //Albums
  @override
  Future<Either<AppErrorHandler, List<AppAlbumModel>>> getAllAlbums({
    bool? refetch,
    required String token,
  }) async {
    try {
      if (refetch == true) {
        return localDataSource.getAllAlbums(
          refetch: refetch,
          token: token,
        );
      } else {
        final hiveAlbums = await queryHiveService.getAllAlbums();
        if (hiveAlbums.isNotEmpty) {
          return Right(
            AppAlbumModel.fromListHiveModel(
              hiveAlbums,
            ),
          );
        } else {
          return Left(
            AppErrorHandler(
              message: 'No songs found',
              status: false,
            ),
          );
        }
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

  // Artists
  @override
  Future<Either<AppErrorHandler, List<AppArtistModel>>> getAllArtists({
    bool? refetch,
    required String token,
  }) async {
    try {
      if (refetch == true) {
        return localDataSource.getAllArtists(
          refetch: refetch,
          token: token,
        );
      } else {
        final hiveArtists = await queryHiveService.getAllArtists();
        if (hiveArtists.isNotEmpty) {
          return Right(
            AppArtistModel.fromListHiveModel(
              hiveArtists,
            ),
          );
        } else {
          return Left(
            AppErrorHandler(
              message: 'No songs found',
              status: false,
            ),
          );
        }
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

  Future<Either<AppErrorHandler, List<AppFolderModel>>> getAllFolders({
    bool? refetch,
    required String token,
  }) async {
    try {
      if (refetch == true) {
        return localDataSource.getAllFolders(
          refetch: refetch,
          token: token,
        );
      } else {
        final hiveFolders = await queryHiveService.getAllFolders();
        if (hiveFolders.isNotEmpty) {
          return Right(
            AppFolderModel.fromListHiveModel(
              hiveFolders,
            ),
          );
        } else {
          return Left(
            AppErrorHandler(
              message: 'No songs found',
              status: false,
            ),
          );
        }
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
