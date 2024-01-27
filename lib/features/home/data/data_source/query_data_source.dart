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
  });

  Future<Either<AppErrorHandler, String>> updateSong({
    required AppSongModel song,
  });

  Future<Either<AppErrorHandler, String>> addSong({
    required AppSongModel song,
  });

  Future<Either<AppErrorHandler, String>> addSongs({
    required List<AppSongModel> songs,
  });

  //

  Future<Either<AppErrorHandler, List<AppAlbumModel>>> getAllAlbums({
    bool? refetch,
  });

  Future<Either<AppErrorHandler, List<AppArtistModel>>> getAllArtists({
    bool? refetch,
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
  }) async {
    try {
      if (refetch == true) {
        // else return data from the local storage
        return localDataSource.getAllSongs(
          onProgress: onProgress,
          first: first,
          refetch: refetch,
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
  }) async {
    try {
      return localDataSource.addSong(
        song: song,
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
  }) async {
    try {
      // else return data from the local storage
      return localDataSource.addSongs(
        songs: songs,
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
  }) async {
    try {
      return localDataSource.updateSong(
        song: song,
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
  }) async {
    try {
      if (refetch == true) {
        return localDataSource.getAllAlbums(
          refetch: refetch,
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
  }) async {
    try {
      if (refetch == true) {
        return localDataSource.getAllArtists(
          refetch: refetch,
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
  }) async {
    try {
      if (refetch == true) {
        return localDataSource.getAllFolders(
          refetch: refetch,
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
