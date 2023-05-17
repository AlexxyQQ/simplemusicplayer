import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/components/audio_controlls.dart';
import 'package:musicplayer/constants/colors.dart';
import 'package:musicplayer/constants/text_style.dart';
import 'package:musicplayer/controllers/audio_player.dart';
import 'package:musicplayer/controllers/query_audio.dart';
import 'package:musicplayer/model/combined_stream_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart' as rx;

class NowPlaying extends StatefulWidget {
  final List<SongModel> song;
  const NowPlaying({super.key, required this.song});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  var audioController = Get.find<AudioPlayerController>();
  // combining 2 streams
  Stream<CombinedAudioStream> get combinedStream => rx.Rx.combineLatest3(
        audioController.playerStateStream,
        audioController.player.positionStream,
        audioController.player.currentIndexStream,
        (playerState, position, currentIndexs) => CombinedAudioStream(
          playerState: playerState,
          processingState: playerState.processingState,
          currentIndex: currentIndexs!,
        ),
      );

  @override
  Widget build(BuildContext context) {
    String where = '';
    if (audioController.player.currentIndex != null) {
      List<String> from =
          widget.song[audioController.player.currentIndex!].data.split('/');
      if (from.isNotEmpty) {
        where = from[from.length - 2];
      } else {
        where = "";
      }
    }
    return DraggableScrollableSheet(
      snap: true,
      minChildSize: 0.5,
      maxChildSize: 1,
      initialChildSize: 1,
      builder: (context, scrollController) {
        return Scaffold(
          backgroundColor: greyColor,
          appBar: AppBar(
            backgroundColor:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? blackColor
                    : whiteColor,
            elevation: 0,
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  "PLAYING FROM",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  where,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            leading: IconButton(
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? blackColor
                      : whiteColor,
              icon: Icon(
                Icons.arrow_downward_rounded,
                size: 35,
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? blackColor
                        : whiteColor,
                icon: Icon(
                  Icons.more_vert_rounded,
                  size: 35,
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: StreamBuilder<CombinedAudioStream>(
            stream: combinedStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final combinedAudioStream = snapshot.data;
                final processingState =
                    combinedAudioStream!.playerState.processingState;
                final playing = combinedAudioStream.playerState.playing;
                final currentIndex = combinedAudioStream.currentIndex;
                return Container(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? blackColor
                      : whiteColor,
                  child: Column(
                    children: [
                      Expanded(
                        child: Hero(
                          tag: widget.song[currentIndex].id,
                          createRectTween: (begin, end) {
                            return RectTween(
                              begin: begin,
                              end: end!.inflate(1.5),
                            );
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: AudioQuery.offlineArtworkWidget(
                                  id: widget.song[currentIndex].id,
                                  fileName: widget
                                      .song[currentIndex].displayNameWOExt,
                                  type: ArtworkType.AUDIO,
                                  artworkType: ArtworkType.AUDIO,
                                  borderRadius: BorderRadius.circular(40),
                                  elevation: 5,
                                  format: ArtworkFormat.PNG,
                                  size: 200,
                                  quality: 200,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  widget.song[currentIndex].title,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                        ? whiteColor
                                        : blackColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ("• ${widget.song[currentIndex].artist.toString()} •"),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      DurationSlider(
                        audioPlayer: audioController,
                        height: 3.5,
                        activeColor: accentColor,
                        thumbRadius: 6,
                        overlayRadius: 10,
                        inactiveColor: greyColor,
                      ),
                      AudioControlls(
                          audioController: audioController,
                          playing: playing,
                          processingState: processingState),
                      MoreControlls(
                        bottomSheetCallback: _bottomSheet,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        );
      },
    );
  }

  void _bottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      useSafeArea: true,
      enableDrag: true,
      builder: (context) => _QueueList(
        songs: widget.song,
      ),
    );
  }
}

class _QueueList extends StatelessWidget {
  final List<SongModel> songs;
  const _QueueList({required this.songs});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    bool scrollOnce = true;
    var audioController = Get.find<AudioPlayerController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? blackColor
            : whiteColor,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          const Text("Q U E U E",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              scrollController.animateTo(
                (audioController.player.currentIndex!) * 73,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            },
            child: Container(
              height: 10,
              width: 50,
              decoration: BoxDecoration(
                color: accentColor2,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final selected = audioController.player.currentIndex! == index;
                if (scrollOnce) {
                  scrollController.animateTo(
                    (audioController.player.currentIndex!) * 73,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                  scrollOnce = false;
                }

                return ListTile(
                  leading: AudioQuery.offlineArtworkWidget(
                    id: songs[index].id,
                    fileName: songs[index].displayNameWOExt,
                    type: ArtworkType.AUDIO,
                    artworkType: ArtworkType.AUDIO,
                    borderRadius: BorderRadius.circular(40),
                    elevation: 5,
                    format: ArtworkFormat.PNG,
                    size: 200,
                    quality: 200,
                    filterQuality: FilterQuality.high,
                  ),
                  title: Text(
                    songs[index].title,
                    softWrap: true,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    style: textStyle(
                      fontSize: 20,
                      color: selected
                          ? accentColor2
                          : MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? whiteColor
                              : blackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    (songs[index].artist.toString()),
                    softWrap: true,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    style: textStyle(
                      fontSize: 15,
                      color: selected ? accentColor2 : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    audioController.playAll(songs, index);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
