import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/constants/colors.dart';
import 'package:musicplayer/constants/text_style.dart';
import 'package:musicplayer/controllers/audio_player.dart';
import 'package:musicplayer/controllers/query_audio.dart';
import 'package:musicplayer/view/music/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AllFolder extends StatefulWidget {
  final List<String> paths;
  const AllFolder({super.key, required this.paths});

  @override
  State<AllFolder> createState() => _AllFolderState();
}

class _AllFolderState extends State<AllFolder>
    with AutomaticKeepAliveClientMixin {
  List<String> _paths = [];
  int orderValue = 0;

  Future<void> getFolders() async {
    _paths = widget.paths;
    sortSongs(order: orderValue);
    setState(() {});
  }

  void sortSongs({required int order}) {
    if (order == 1) {
      _paths = _paths.reversed.toList();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    getFolders();

    var contoller = AudioQuery();
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
                      orderValue = value;
                      sortSongs(order: orderValue);
                      setState(() {});
                    },
                    itemBuilder: (context) {
                      final List<String> orderTypes = ["Aes", "Dec"];

                      final menuList = <PopupMenuEntry<int>>[];

                      menuList.addAll(
                        orderTypes
                            .map(
                              (e) => PopupMenuItem(
                                value: orderTypes.indexOf(e),
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
                child: Text('${_paths.length} Folders'),
              )
            ],
          ),
          widget.paths.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'No Folders Found',
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      shrinkWrap: true,
                      itemCount: _paths.length,
                      itemExtent: 70.0,
                      itemBuilder: (context, index) {
                        if (_paths.isEmpty) {
                          return const SizedBox();
                        } else {
                          return ListTile(
                            onTap: () async {
                              final List<SongModel> songs =
                                  await contoller.getFolderSongs(_paths[index]);
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => _FolderMusic(
                                    folderName: _paths[index].split('/').last,
                                    allSongs: songs,
                                  ),
                                ),
                              );
                            },
                            leading: Icon(
                              Icons.folder_rounded,
                              size: 35,
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? whiteColor
                                      : blackColor,
                            ),
                            title: Text(
                              _paths[index].split('/').last,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
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
}

class _FolderMusic extends StatefulWidget {
  final List<SongModel> allSongs;
  final String folderName;
  const _FolderMusic(
      {Key? key, required this.allSongs, required this.folderName})
      : super(key: key);

  @override
  State<_FolderMusic> createState() => _FolderMusicState();
}

class _FolderMusicState extends State<_FolderMusic> {
  List<SongModel> _songs = [];
  int sortValue = 0;
  int orderValue = 0;

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
  Widget build(BuildContext context) {
    var audioPlayerController = Get.find<AudioPlayerController>();

    getSongs();
    return Scaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? blackColor
              : whiteColor,
      appBar: AppBar(
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? blackColor
                : whiteColor,
        title: Text(
          widget.folderName,
          style: textStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? whiteColor
                : blackColor,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? whiteColor
                : blackColor,
          ),
        ),
      ),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
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
                    return ListTile(
                      onTap: () async {
                        audioPlayerController.playAll(_songs, index);
                        _bottomSheet();
                      },
                      leading: AudioQuery.offlineArtworkWidget(
                        id: _songs[index].id,
                        fileName: _songs[index].displayNameWOExt,
                        type: ArtworkType.AUDIO,
                        artworkType: ArtworkType.AUDIO,
                        borderRadius: BorderRadius.circular(50),
                        format: ArtworkFormat.PNG,
                      ),
                      title: Text(
                        _songs[index].title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(_songs[index].artist.toString()),
                      trailing: Text(
                        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      ),
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
      builder: (context) => NowPlaying(song: _songs),
    );
  }
}
