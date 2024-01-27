import 'dart:convert';
import 'package:equatable/equatable.dart';

import 'package:simplemusicplayer/core/utils/song_model_map_converter.dart';
import 'package:simplemusicplayer/features/home/data/model/hive/song_hive_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongEntity extends Equatable {
  final int id;

  final String data;

  final String? uri;

  final String displayName;

  final String displayNameWOExt;

  final int size;

  final String? album;

  final String? albumId;

  final String? artist;

  final String? artistId;

  final String? genre;

  final String? genreId;

  final int? bookmark;

  final String? composer;

  final int? dateAdded;

  final int? dateModified;

  final int? duration;

  final String title;

  final int? track;

  final String fileExtension;

  final bool? isAlarm;

  final bool? isAudioBook;

  final bool? isMusic;

  final bool? isNotification;

  final bool? isPodcast;

  final bool isRingtone;

  final String? albumArt;

  final bool? isPublic;

  final String? lyrics;

  final bool isFavorite;

  const SongEntity({
    required this.id,
    required this.data,
    required this.uri,
    required this.displayName,
    required this.displayNameWOExt,
    required this.size,
    this.albumArt,
    this.album,
    this.albumId,
    this.artist,
    this.artistId,
    this.genre,
    this.genreId,
    this.bookmark,
    this.composer,
    this.dateAdded,
    this.dateModified,
    this.duration,
    required this.title,
    this.track,
    required this.fileExtension,
    this.isAlarm,
    this.isAudioBook,
    this.isMusic,
    this.isNotification,
    this.isPodcast,
    required this.isRingtone,
    this.isPublic,
    this.lyrics,
    this.isFavorite = false,
  });

  SongEntity copyWith({
    int? id,
    String? data,
    String? uri,
    String? displayName,
    String? displayNameWOExt,
    int? size,
    String? album,
    String? albumId,
    String? artist,
    String? artistId,
    String? genre,
    String? genreId,
    int? bookmark,
    String? composer,
    int? dateAdded,
    int? dateModified,
    int? duration,
    String? title,
    int? track,
    String? fileExtension,
    bool? isAlarm,
    bool? isAudioBook,
    bool? isMusic,
    bool? isNotification,
    bool? isPodcast,
    bool? isRingtone,
    String? albumArt,
    bool? isPublic,
    String? lyrics,
    bool? isFavorite,
  }) {
    return SongEntity(
      id: id ?? this.id,
      data: data ?? this.data,
      uri: uri ?? this.uri,
      displayName: displayName ?? this.displayName,
      displayNameWOExt: displayNameWOExt ?? this.displayNameWOExt,
      size: size ?? this.size,
      album: album ?? this.album,
      albumId: albumId ?? this.albumId,
      artist: artist ?? this.artist,
      artistId: artistId ?? this.artistId,
      genre: genre ?? this.genre,
      genreId: genreId ?? this.genreId,
      bookmark: bookmark ?? this.bookmark,
      composer: composer ?? this.composer,
      dateAdded: dateAdded ?? this.dateAdded,
      dateModified: dateModified ?? this.dateModified,
      duration: duration ?? this.duration,
      title: title ?? this.title,
      track: track ?? this.track,
      fileExtension: fileExtension ?? this.fileExtension,
      isAlarm: isAlarm ?? this.isAlarm,
      isAudioBook: isAudioBook ?? this.isAudioBook,
      isMusic: isMusic ?? this.isMusic,
      isNotification: isNotification ?? this.isNotification,
      isPodcast: isPodcast ?? this.isPodcast,
      isRingtone: isRingtone ?? this.isRingtone,
      albumArt: albumArt ?? this.albumArt,
      isPublic: isPublic ?? this.isPublic,
      lyrics: lyrics ?? this.lyrics,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'data': data,
      'uri': uri,
      'display_name': displayName,
      'display_name_wo_ext': displayNameWOExt,
      'size': size,
      'album': album,
      'album_id': albumId,
      'artist': artist,
      'artist_id': artistId,
      'genre': genre,
      'genre_id': genreId,
      'bookmark': bookmark,
      'composer': composer,
      'date_added': dateAdded,
      'date_modified': dateModified,
      'duration': duration,
      'title': title,
      'track': track,
      'file_extension': fileExtension,
      'is_alarm': isAlarm,
      'is_audiobook': isAudioBook,
      'is_music': isMusic,
      'is_notification': isNotification,
      'is_podcast': isPodcast,
      'is_ringtone': isRingtone,
      'album_art': albumArt,
      'is_public': isPublic,
      'lyrics': lyrics,
      'is_favorite': isFavorite,
    };
  }

  factory SongEntity.fromModelMap(Map<String, dynamic> map) {
    return SongEntity(
      id: map['_id'] as int,
      data: map['_data'] as String,
      uri: map['_uri'] != null ? map['_uri'] as String : null,
      displayName: map['_display_name'] as String,
      displayNameWOExt: map['_display_name_wo_ext'] as String,
      size: map['_size'] as int,
      album: map['album'] != null ? map['album'] as String : null,
      albumId: map['album_id'] != null ? "${map['album_id']}" : null,
      artist: map['artist'] != null ? map['artist'] as String : null,
      artistId: map['artist_id'] != null ? "${map['artist_id']}" : null,
      genre: map['genre'] != null ? map['genre'] as String : null,
      genreId: map['genre_id'] != null ? map['genre_id'] as String : null,
      bookmark: map['bookmark'] != null ? map['bookmark'] as int : null,
      composer: map['composer'] != null ? map['composer'] as String : null,
      dateAdded: map['date_added'] != null ? map['date_added'] as int : null,
      dateModified:
          map['date_modified'] != null ? map['date_modified'] as int : null,
      duration: map['duration'] != null ? map['duration'] as int : null,
      title: map['title'] as String,
      track: map['track'] != null ? map['track'] as int : null,
      fileExtension: map['file_extension'] as String,
      isAlarm: map['is_alarm'] != null ? map['is_alarm'] as bool : null,
      isAudioBook:
          map['is_audiobook'] != null ? map['is_audiobook'] as bool : null,
      isMusic: map['is_music'] != null ? map['is_music'] as bool : null,
      isNotification: map['is_notification'] != null
          ? map['is_notification'] as bool
          : null,
      isPodcast: map['is_podcast'] != null ? map['is_podcast'] as bool : null,
      isRingtone: map['is_ringtone'] as bool,
      albumArt: map['album_art'] != null ? map['album_art'] as String : '',
      isPublic: map['is_public'] != null ? map['is_public'] as bool : null,
      lyrics: map['lyrics'] != null ? map['lyrics'] as String : null,
      isFavorite:
          map['is_favorite'] != null ? map['is_favorite'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SongEntity.fromJson(String source) =>
      SongEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongEntity Details:\n'
        '  - ID: $id\n'
        '  - Data: $data\n'
        '  - URI: $uri\n'
        '  - Display Name: $displayName\n'
        '  - Display Name Without Extension: $displayNameWOExt\n'
        '  - Size: $size\n'
        '  - Album: $album\n'
        '  - Album ID: $albumId\n'
        '  - Artist: $artist\n'
        '  - Artist ID: $artistId\n'
        '  - Genre: $genre\n'
        '  - Genre ID: $genreId\n'
        '  - Bookmark: $bookmark\n'
        '  - Composer: $composer\n'
        '  - Date Added: $dateAdded\n'
        '  - Date Modified: $dateModified\n'
        '  - Duration: $duration\n'
        '  - Title: $title\n'
        '  - Track: $track\n'
        '  - File Extension: $fileExtension\n'
        '  - Is Alarm: $isAlarm\n'
        '  - Is Audio Book: $isAudioBook\n'
        '  - Is Music: $isMusic\n'
        '  - Is Notification: $isNotification\n'
        '  - Is Podcast: $isPodcast\n'
        '  - Album Art: $albumArt\n'
        '  - Is Public: $isPublic\n'
        '  - Lyrics: $lyrics\n'
        '  - Is Favorite: $isFavorite\n'
        '  - Is Ringtone: $isRingtone';
  }

  factory SongEntity.fromMap(Map<String, dynamic> map) {
    return SongEntity(
      id: map['id'] as int,
      data: map['data'] as String,
      albumArt: map['album_art'] as String,
      uri: map['uri'] != null ? map['uri'] as String : null,
      displayName: map['display_name'] as String,
      displayNameWOExt: map['display_name_wo_ext'] as String,
      size: map['size'] as int,
      album: map['album'] != null ? map['album'] as String : null,
      albumId: map['album_id'] != null ? map['album_id'] as String : null,
      artist: map['artist'] != null ? map['artist'] as String : null,
      artistId: map['artist_id'] != null ? map['artist_id'] as String : null,
      genre: map['genre'] != null ? map['genre'] as String : null,
      genreId: map['genre_id'] != null ? map['genre_id'] as String : null,
      bookmark: map['bookmark'] != null ? map['bookmark'] as int : null,
      composer: map['composer'] != null ? map['composer'] as String : null,
      dateAdded: map['date_added'] != null ? map['date_added'] as int : null,
      dateModified:
          map['date_modified'] != null ? map['date_modified'] as int : null,
      duration: map['duration'] != null ? map['duration'] as int : null,
      title: map['title'] as String,
      track: map['track'] != null ? map['track'] as int : null,
      fileExtension: map['file_extension'] as String,
      isAlarm: map['is_alarm'] != null ? map['is_alarm'] as bool : null,
      isAudioBook:
          map['is_audio_book'] != null ? map['is_audio_book'] as bool : null,
      isMusic: map['is_music'] != null ? map['is_music'] as bool : null,
      isNotification: map['is_notification'] != null
          ? map['is_notification'] as bool
          : null,
      isPodcast: map['is_podcast'] != null ? map['is_podcast'] as bool : null,
      isRingtone: map['is_ringtone'] as bool,
      isPublic: map['is_public'] != null ? map['is_public'] as bool : null,
      lyrics: map['lyrics'] != null ? map['lyrics'] as String : null,
      isFavorite:
          map['is_favorite'] != null ? map['is_favorite'] as bool : false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        data,
        uri,
        displayName,
        displayNameWOExt,
        size,
        album,
        albumId,
        artist,
        artistId,
        genre,
        genreId,
        bookmark,
        composer,
        dateAdded,
        dateModified,
        duration,
        title,
        track,
        fileExtension,
        isAlarm,
        isAudioBook,
        isMusic,
        isNotification,
        isPodcast,
        isRingtone,
        albumArt,
        isPublic,
        lyrics,
        isFavorite,
      ];

  SongHiveModel toHiveModel() {
    return SongHiveModel(
      id: id,
      data: data,
      uri: uri,
      displayName: displayName,
      displayNameWOExt: displayNameWOExt,
      size: size,
      album: album,
      albumId: albumId,
      artist: artist,
      artistId: artistId,
      genre: genre,
      genreId: genreId,
      bookmark: bookmark,
      composer: composer,
      dateAdded: dateAdded,
      dateModified: dateModified,
      duration: duration,
      title: title,
      track: track,
      fileExtension: fileExtension,
      isAlarm: isAlarm,
      isAudioBook: isAudioBook,
      isMusic: isMusic,
      isNotification: isNotification,
      isPodcast: isPodcast,
      isRingtone: isRingtone,
      albumArt: albumArt,
      isPublic: isPublic,
      lyrics: lyrics,
      isFavorite: isFavorite,
    );
  }

  static List<SongHiveModel> toListHiveModel(List<SongEntity> songs) {
    return songs.map((e) => e.toHiveModel()).toList();
  }

  static List<SongEntity> fromListHiveModel(List<SongHiveModel> songs) {
    return songs.map((e) => e.toEntity()).toList();
  }

  static SongEntity formSongModel(SongModel song) {
    return SongEntity.fromModelMap(convertMap(song.getMap));
  }

  static List<SongEntity> fromListSongModel(List<SongModel> songs) {
    return songs.map((e) => formSongModel(e)).toList();
  }
}
