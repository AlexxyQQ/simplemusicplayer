import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:on_audio_query/on_audio_query.dart';

class AudioPlayerController {
  static final AudioPlayerController _singleton =
      AudioPlayerController._internal();

  final _player = AudioPlayer();

  List<SongModel> _songs = [];

  factory AudioPlayerController() {
    return _singleton;
  }

  AudioPlayerController._internal();

  AudioPlayer get player => _player;
  List<SongModel> get songs => _songs;
  Duration get position => _player.position;

  /// Plays the songs from the list
  /// [songs] is the list of songs to be played(List<SongModel>)
  /// [index] is the index of the song to be played(int)
  Future<void> playAll(List<SongModel> songs, int index) async {
    try {
      _songs = songs;
      final String tempPath = await path_provider
          .getTemporaryDirectory()
          .then((value) => value.path);
      await _player.setAudioSource(
        ConcatenatingAudioSource(
          children: songs.map(
            (song) {
              return AudioSource.uri(
                Uri.parse(song.data),
                tag: MediaItem(
                  id: "${song.id}",
                  artist: song.artist,
                  title: song.title,
                  artHeaders: {
                    "User-Agent":
                        "Mozilla/5.0 (Linux; Android 10; SM-A205U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Mobile Safari/537.36"
                  },
                  artUri: Uri.parse(
                      'File://$tempPath/${song.displayNameWOExt}.png'),
                ),
              );
            },
          ).toList(),
        ),
        initialIndex: index,
      );

      await _player.play();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  

  // Streams
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
}
