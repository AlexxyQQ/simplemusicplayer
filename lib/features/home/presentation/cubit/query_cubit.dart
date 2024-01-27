import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemusicplayer/features/home/data/data_source/local_data_source/hive_service/query_hive_service.dart';
import 'package:simplemusicplayer/features/home/data/model/hive/album_hive_model.dart';
import 'package:simplemusicplayer/features/home/domain/entity/recently_played_entity.dart';
import 'package:simplemusicplayer/features/home/domain/entity/song_entity.dart';
import 'package:simplemusicplayer/features/home/domain/usecase/get_recently_played_usecase.dart';
import 'package:simplemusicplayer/features/home/domain/usecase/update_song_usecase.dart';
import 'package:simplemusicplayer/injection/app_injection_container.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/common/hive/hive_service/setting_hive_service.dart';
import '../../../../core/failure/error_handler.dart';
import '../../domain/usecase/get_all_albums_usecase.dart';
import '../../domain/usecase/get_all_artist_usecase.dart';
import '../../domain/usecase/get_all_folders_usecase.dart';
import '../../domain/usecase/get_all_songs_usecase.dart';
import 'home_state.dart';

class QueryCubit extends Cubit<HomeState> {
  final GetAllSongsUseCase getAllSongsUseCase;
  final GetAllAlbumsUsecase getAllAlbumsUsecase;
  final GetAllArtistsUsecase getAllArtistsUsecase;
  final GetAllFoldersUsecase getAllFoldersUsecase;
  final SettingsHiveService settingsHiveService;
  final QueryHiveService queryHiveService;
  final GetRecentlyPlayedUsecase getRecentlyPlayedUsecase;
  final UpdateRecentlyPlayedUsecase updateRecentlyPlayedUsecase;
  final UpdateSongUsecase updateSongUsecase;

  QueryCubit({
    required this.getAllSongsUseCase,
    required this.getAllAlbumsUsecase,
    required this.getAllArtistsUsecase,
    required this.getAllFoldersUsecase,
    required this.settingsHiveService,
    required this.queryHiveService,
    required this.getRecentlyPlayedUsecase,
    required this.updateRecentlyPlayedUsecase,
    required this.updateSongUsecase,
  }) : super(HomeState.initial()) {
    init();
  }

  void init() async {
    final settings = await settingsHiveService.getSettings();
    // Fetch Data
    await getAllSongs(first: settings.firstTime, refetch: true);
    await getAllAlbums(first: settings.firstTime, refetch: true);
    await getAllArtists(first: settings.firstTime, refetch: true);
    await getAllFolders(first: settings.firstTime, refetch: true);
    await getRecentlyPlayedSongs();
    await getFavouriteSongs();
    // Update Settings
    await get<SettingsHiveService>().updateSettings(
      settings.copyWith(
        firstTime: false,
        goHome: true,
      ),
    );
  }

  Future<void> getAllSongs({
    bool? first,
    bool? refetch,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        error: null,
        count: 0,
      ),
    );
    try {
      // get permission
      await Permission.storage.request();
      final data = await getAllSongsUseCase.call(
        GetQueryParams(
          onProgress: (count) {
            emit(
              state.copyWith(
                isLoading: true,
                isSuccess: false,
                error: null,
                count: count,
              ), // Pass the count of songs
            );
          },
          first: first,
          refetch: refetch ?? false,
        ),
      );

      data.fold((l) => Left(l), (r) {
        r.sort(
          (a, b) => a.title.compareTo(b.title),
        );

        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            error: null,
            count: state.count,
            songs: r,
          ),
        ); // Pass the final list of songs
      });
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: AppErrorHandler(message: e.toString(), status: false),
          count: state.count,
        ),
      );
    }
  }

  Future<void> getAllAlbums({
    bool? first,
    bool? refetch,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        error: null,
      ),
    );
    try {
      final data = await getAllAlbumsUsecase.call(
        GetQueryParams(
          refetch: refetch ?? false,
        ),
      );

      data.fold((l) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            error: l,
            count: state.count,
          ),
        );
      }, (r) {
        final songs = state.songs;
        final updatedAlbums = r.map((album) {
          final albumSongs =
              songs.where((song) => song.albumId == album.id).toList();
          return album.copyWith(songs: albumSongs);
        }).toList();

        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            error: null,
            count: state.count,
            albums: updatedAlbums,
          ),
        );

        queryHiveService.updateAlbums(
          updatedAlbums.map((e) => AlbumHiveModel.fromMap(e.toMap())).toList(),
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: AppErrorHandler(message: e.toString(), status: false),
          count: state.count,
        ),
      );
    }
  }

  Future<void> getAllArtists({
    bool? first,
    bool? refetch,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        error: null,
      ),
    );
    try {
      final data = await getAllArtistsUsecase.call(
        GetQueryParams(
          refetch: refetch ?? false,
        ),
      );

      data.fold((l) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            error: l,
            count: state.count,
          ),
        );
      }, (r) {
        final songs = state.songs;
        final updatedArtists = r.map((artist) {
          final artistSongs = songs
              .where((song) => song.artistId.toString() == artist.id.toString())
              .toList();
          return artist.copyWith(songs: artistSongs);
        }).toList();

        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            error: null,
            count: state.count,
            artists: updatedArtists,
          ),
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: AppErrorHandler(message: e.toString(), status: false),
          count: state.count,
        ),
      );
    }
  }

  Future<void> getAllFolders({
    bool? first,
    bool? refetch,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        error: null,
      ),
    );
    try {
      final data = await getAllFoldersUsecase.call(
        GetQueryParams(
          refetch: refetch ?? false,
        ),
      );

      data.fold((l) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            error: l,
            count: state.count,
          ),
        );
      }, (r) {
        final songs = state.songs;
        final updatedFolders = r.map((folder) {
          final folderSongs = songs
              .where(
                (song) =>
                    song.data.toString().replaceAll(
                          "${song.displayNameWOExt}.${song.fileExtension}",
                          '',
                        ) ==
                    "${folder.path}/",
              )
              .toList();
          return folder.copyWith(songs: folderSongs);
        }).toList();

        if (r.isEmpty) {
          // fetch all songs
          getAllSongs(first: false, refetch: true);
        }

        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            error: null,
            count: state.count,
            folders: updatedFolders,
          ),
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: AppErrorHandler(message: e.toString(), status: false),
          count: state.count,
        ),
      );
    }
  }

  Future<void> getRecentlyPlayedSongs() async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        error: null,
      ),
    );
    try {
      final data = await getRecentlyPlayedUsecase.call(null);

      data.fold((l) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            recentlyPlayed: RecentlyPlayedEntity.empty(),
            count: state.count,
          ),
        );
      }, (r) {
        RecentlyPlayedEntity recentlyPlayed = r;
        // Sort the list and remove duplicates
        recentlyPlayed.songs.sort((a, b) => a.title.compareTo(b.title));
        recentlyPlayed = recentlyPlayed.copyWith(
          songs: recentlyPlayed.songs.toSet().toList(),
        );

        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            error: null,
            count: state.count,
            recentlyPlayed: recentlyPlayed,
          ),
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          error: null,
          count: state.count,
          recentlyPlayed: RecentlyPlayedEntity.empty(),
        ),
      );
    }
  }

  Future<void> updateRecentlyPlayedSongs({required SongEntity song}) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        error: null,
      ),
    );
    try {
      // Check the song is already in the list
      final isAlreadyInList = state.recentlyPlayed?.songs
          .where((element) => element.id == song.id)
          .isNotEmpty;

      if (isAlreadyInList!) {
        return;
      }

      final data = await updateRecentlyPlayedUsecase.call(song);
      data.fold((l) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            error: l,
            count: state.count,
          ),
        );
      }, (r) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            error: null,
            count: state.count,
          ),
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: AppErrorHandler(message: e.toString(), status: false),
          count: state.count,
        ),
      );
    }
  }

  Future<void> getFavouriteSongs() async {
    await getAllSongs(first: false, refetch: false);
    final List<SongEntity> fav = [];
    for (var song in state.songs) {
      if (song.isFavorite) {
        fav.add(song);
      }
    }

    emit(
      state.copyWith(
        isLoading: false,
        isSuccess: true,
        error: null,
        favouriteSongs: fav,
      ),
    );
  }

  Future<void> updateFavouriteSongs({
    required SongEntity song,
  }) async {
    final setting = await get<SettingsHiveService>().getSettings();
    await updateSongUsecase.call(
      UpdateParams(
        song: song,
        offline: setting.offline,
      ),
    );
    getAllSongs(first: false, refetch: false);
    getFavouriteSongs();
  }

  void update(HomeState copyWith) {
    emit(copyWith);
  }

  void updateSelectedIndex(int index) {
    state.pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    emit(
      state.copyWith(
        selectedIndex: index,
        pageController: state.pageController,
      ),
    );
  }
}
