import 'package:just_audio/just_audio.dart';

class CombinedAudioStream {
  final PlayerState playerState;
  final ProcessingState processingState;
  final int currentIndex;
  

  CombinedAudioStream({
    required this.playerState,
    required this.processingState,
    required this.currentIndex,
  });
}
