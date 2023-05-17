import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/constants/colors.dart';
import 'package:musicplayer/constants/globals_constants.dart';
import 'package:musicplayer/controllers/audio_player.dart';
import 'package:musicplayer/controllers/query_audio.dart';
import 'package:musicplayer/view/music/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:http/http.dart' as http;

class AllMusic extends StatefulWidget {
  final List<SongModel> allSongs;
  const AllMusic({super.key, required this.allSongs});

  @override
  State<AllMusic> createState() => _AllMusicState();
}

class _AllMusicState extends State<AllMusic>
    with AutomaticKeepAliveClientMixin {
  List<SongModel> _songs = [];
  int sortValue = 0;
  int orderValue = 0;
  List<String> filePaths = [];

  Future<void> fileLog() async {
    var token = Hive.box('user').get('token');
    try {
      final fileResponse = await http.get(Uri.parse("$URI/file/files"),
          headers: {"Authorization": 'Bearer $token'});
      final fileData = jsonDecode(fileResponse.body);

      for (var element in fileData) {
        // if element['path'] is in songs, then remove it from songs
        for (var i = 0; i < _songs.length; i++) {
          if (_songs[i].data.split('/').last == element['name']) {
            // add removed songes to hive
            filePaths.add(_songs[i].data);
          }
        }
      }
    } catch (e) {}
  }

  Future<void> getSongs() async {
    _songs = widget.allSongs;
    sortSongs(sortVal: sortValue, order: orderValue);
    setState(() {});
  }

  void sortSongs({required int sortVal, required int order}) {
    switch (sortVal) {
      case 0:
        _songs.sort(
          (a, b) => a.title
              .toString()
              .toUpperCase()
              .compareTo(b.title.toString().toUpperCase()),
        );

        break;
      case 1:
        _songs.sort(
          (a, b) => a.dateAdded
              .toString()
              .toUpperCase()
              .compareTo(b.dateAdded.toString().toUpperCase()),
        );
        break;
      case 2:
        _songs.sort(
          (a, b) => a.album
              .toString()
              .toUpperCase()
              .compareTo(b.album.toString().toUpperCase()),
        );
        break;
      case 3:
        _songs.sort(
          (a, b) => a.artist
              .toString()
              .toUpperCase()
              .compareTo(b.artist.toString().toUpperCase()),
        );
        break;
      case 4:
        try {
          _songs.sort(
            (a, b) => a.duration!.compareTo(b.duration!),
          );
        } on Exception catch (e) {
          debugPrint(e.toString());
        }
        break;
      default:
        _songs.sort(
          (a, b) => a.title
              .toString()
              .toUpperCase()
              .compareTo(b.title.toString().toUpperCase()),
        );
        break;
    }
    if (order == 1) {
      _songs = _songs.reversed.toList();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    fileLog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    getSongs();

    var audioPlayerController = Get.find<AudioPlayerController>();
    return Scaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? blackColor
              : whiteColor,
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: PopupMenuButton(
                    icon: Icon(
                      Icons.swap_vert_rounded,
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? whiteColor
                          : blackColor,
                    ),
                    onSelected: (int value) {
                      if (value < 5) {
                        sortValue = value;
                      } else {
                        orderValue = value - 5;
                        setState(() {});
                      }
                      sortSongs(sortVal: sortValue, order: orderValue);
                      setState(() {});
                    },
                    itemBuilder: (context) {
                      final List<String> sortTypes = [
                        "Name",
                        "Date",
                        "Album",
                        "Artist",
                        "Duration"
                      ];
                      final List<String> orderTypes = ["Aes", "Dec"];

                      final menuList = <PopupMenuEntry<int>>[];
                      menuList.addAll(
                        sortTypes
                            .map(
                              (e) => PopupMenuItem(
                                value: sortTypes.indexOf(e),
                                child: Row(
                                  children: [
                                    if (sortValue == sortTypes.indexOf(e))
                                      Icon(
                                        Icons.check_rounded,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? whiteColor
                                            : greyColor,
                                      )
                                    else
                                      const SizedBox(),
                                    const SizedBox(width: 10),
                                    Text(
                                      e,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      );
                      menuList.add(
                        const PopupMenuDivider(
                          height: 10,
                        ),
                      );
                      menuList.addAll(
                        orderTypes
                            .map(
                              (e) => PopupMenuItem(
                                value: sortTypes.length + orderTypes.indexOf(e),
                                child: Row(
                                  children: [
                                    if (orderValue == orderTypes.indexOf(e))
                                      Icon(
                                        Icons.check_rounded,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? whiteColor
                                            : greyColor,
                                      )
                                    else
                                      const SizedBox(),
                                    const SizedBox(width: 10),
                                    Text(
                                      e,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      );
                      return menuList;
                    }),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text('${_songs.length} Songs'),
              )
            ],
          ),
          widget.allSongs.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'No Songs Found',
                      style: TextStyle(
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? whiteColor
                            : blackColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      fileLog();
                      _songs = await AudioQuery().getSongs(recheck: true);
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() {});
                    },
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      shrinkWrap: true,
                      itemCount: _songs.length,
                      itemExtent: 70.0,
                      itemBuilder: (context, index) {
                        if (_songs.isEmpty) {
                          return const SizedBox();
                        } else {
                          final ms = _songs[index].duration!;
                          Duration duration = Duration(milliseconds: ms);
                          int minutes = duration.inMinutes;
                          int seconds = duration.inSeconds.remainder(60);
                          bool uploaded =
                              filePaths.contains(_songs[index].data);
                          // check if song exists in device
                          if (!File(_songs[index].data).existsSync()) {
                            _songs.removeAt(index);
                          }
                          return ListTile(
                            onTap: () async {
                              if (audioPlayerController.player.playing) {
                                audioPlayerController.playAll(_songs, index);
                              } else {
                                _bottomSheet();
                                audioPlayerController.playAll(_songs, index);
                              }
                            },
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: uploaded
                                    ? Colors.green
                                    : Colors.transparent,
                              ),
                              child: AudioQuery.offlineArtworkWidget(
                                id: _songs[index].id,
                                fileName: _songs[index].displayNameWOExt,
                                type: ArtworkType.AUDIO,
                                artworkType: ArtworkType.AUDIO,
                                borderRadius: BorderRadius.circular(50),
                                format: ArtworkFormat.PNG,
                              ),
                            ),
                            title: Text(
                              _songs[index].title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Text(_songs[index].artist.toString()),
                            trailing: Text(
                                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'),
                          );
                        }
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _bottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        useSafeArea: true,
        builder: (context) => NowPlaying(song: _songs));
  }
}
