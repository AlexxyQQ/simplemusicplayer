import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class AudioQuery {
  static final _audioQuery = OnAudioQuery();

  Future<void> requestPermission() async {
    while (!await _audioQuery.permissionsStatus()) {
      await _audioQuery.permissionsRequest();
    }
  }

  Future<List<SongModel>> getSongs({bool recheck = true}) async {
    try {
      final box = Hive.box('songs');
      if (recheck) {
        const MethodChannel channel =
            MethodChannel('com.lucasjosino.on_audio_query');
        final List<dynamic> resultSongs = await channel.invokeMethod(
          "querySongs",
          {
            "sortType": SongSortType.TITLE.index,
            "orderType": OrderType.ASC_OR_SMALLER.index,
            "uri": UriType.EXTERNAL.index,
            "ignoreCase": true,
          },
        );
        box.put('song_cache', resultSongs);
        return resultSongs.map((e) => SongModel(e)).toList();
      }
      if (box.get('song_cache') != null) {
        final List<dynamic> resultSongs = await box.get('song_cache');
        return resultSongs.map((e) => SongModel(e)).toList();
      } else {
        const MethodChannel channel =
            MethodChannel('com.lucasjosino.on_audio_query');
        final List<dynamic> resultSongs = await channel.invokeMethod(
          "querySongs",
          {
            "sortType": SongSortType.TITLE.index,
            "orderType": OrderType.ASC_OR_SMALLER.index,
            "uri": UriType.EXTERNAL.index,
            "ignoreCase": true,
          },
        );
        box.put('song_cache', resultSongs);
        return resultSongs.map((e) => SongModel(e)).toList();
      }
    } catch (e) {
      debugPrint('$e');
      return [];
    }
  }

  Future<List<String>> getFolders({bool recheck = false}) async {
    try {
      return await _audioQuery.queryAllPath();
    } catch (e) {
      return [];
    }
  }

  Future<List<ArtistModel>> getArtists() async {
    try {
      return await _audioQuery.queryArtists(
        sortType: ArtistSortType.ARTIST,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );
    } catch (e) {
      return [];
    }
  }

  Future<List<SongModel>> getFolderSongs(String path,
      {bool recheck = false}) async {
    return await _audioQuery.querySongs(
      path: path,
      uriType: UriType.EXTERNAL,
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
    );
  }

  Future<List<SongModel>> getArtistSongs(String artist,
      {bool recheck = false}) async {
    var all = await _audioQuery.querySongs(
      uriType: UriType.EXTERNAL,
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
    );
    return all.where((element) => element.artist == artist).toList();
  }

  static Future<String> queryNSave({
    required int id,
    required ArtworkType type,
    required String fileName,
    int size = 200,
    int quality = 100,
    ArtworkFormat format = ArtworkFormat.PNG,
  }) async {
    final String tempPath =
        await path_provider.getTemporaryDirectory().then((value) => value.path);
    final File file = File('$tempPath/$fileName.png');

    if (!await file.exists()) {
      await file.create();
      final Uint8List? image = await _audioQuery.queryArtwork(
        id,
        type,
        format: format,
        size: size,
        quality: quality,
      );
      if (image != null) {
        file.writeAsBytesSync(image);
      }
    }
    return file.path;
  }

  static Widget offlineArtworkWidget({
    required int id,
    required ArtworkType type,
    required String fileName,
    int size = 200,
    int quality = 80,
    ArtworkFormat format = ArtworkFormat.JPEG,
    ArtworkType artworkType = ArtworkType.AUDIO,
    BorderRadius? borderRadius,
    Clip clipBehavior = Clip.antiAlias,
    BoxFit fit = BoxFit.cover,
    FilterQuality filterQuality = FilterQuality.low,
    double height = 50.0,
    double width = 50.0,
    double elevation = 5,
    ImageRepeat imageRepeat = ImageRepeat.noRepeat,
    bool gaplessPlayback = true,
    Widget? errorWidget,
    Widget? placeholder,
  }) {
    return FutureBuilder<String>(
      future: queryNSave(
        id: id,
        type: type,
        format: format,
        quality: quality,
        size: size,
        fileName: fileName,
      ),
      builder: (context, item) {
        if (item.data != null &&
            item.data!.isNotEmpty &&
            File(item.data!).existsSync() &&
            File(item.data!).lengthSync() > 0) {
          final File file = File(item.data!);
          return Card(
            elevation: elevation,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(7.0),
            ),
            clipBehavior: clipBehavior,
            child: Image(
              image: FileImage(file),
              gaplessPlayback: gaplessPlayback,
              repeat: imageRepeat,
              width: width,
              height: height,
              fit: fit,
              filterQuality: filterQuality,
              errorBuilder: (context, exception, stackTrace) {
                return errorWidget ??
                    Image(
                      fit: BoxFit.cover,
                      height: height,
                      width: width,
                      image: const AssetImage('assets/splash_screen/icon.png'),
                    );
              },
            ),
          );
        }
        return Card(
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(7.0),
          ),
          clipBehavior: clipBehavior,
          child: placeholder ??
              Image(
                fit: BoxFit.cover,
                height: height,
                width: width,
                image: const AssetImage('assets/splash_screen/icon.png'),
              ),
        );
      },
    );
  }
}
