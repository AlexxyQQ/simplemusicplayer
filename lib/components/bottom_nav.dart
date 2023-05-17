import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/constants/colors.dart';
import 'package:musicplayer/controllers/audio_player.dart';
import 'package:musicplayer/controllers/query_audio.dart';
import 'package:musicplayer/model/combined_stream_model.dart';
import 'package:musicplayer/provider/fileupload.dart';
import 'package:musicplayer/view/music/all_artist_page.dart';
import 'package:musicplayer/view/music/all_folders_page.dart';
import 'package:musicplayer/view/music/all_songs_page.dart';
import 'package:musicplayer/view/music/now_playing.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:on_audio_query/on_audio_query.dart';

class BottomNav extends StatefulWidget {
  final String directory;
  final int intIndex;
  const BottomNav({Key? key, this.directory = '', this.intIndex = 0})
      : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  var queryController = AudioQuery();
  var audioController = Get.put(AudioPlayerController());

  late List<_BottomItem> bottomItems;
  late List<Widget> bottomOptions;

  List<String> titles = [
    "Music",
    "Folder",
    "Artists",
  ];

  _onSelectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _handlingIsSelected(int pos) {
    return _selectedIndex == pos;
  }

  initBottomItems() {
    bottomItems = [
      _BottomItem(
        tooltip: "Music",
        iconSize: 20,
        iconSelected: Icons.music_note_rounded,
        iconUnSelected: Icons.music_note_outlined,
        onPressed: () async {
          _onSelectItem(0);
        },
        isSelected: _handlingIsSelected(0),
      ),
      _BottomItem(
        tooltip: "Folder",
        iconSize: 20,
        iconSelected: Icons.folder_rounded,
        iconUnSelected: Icons.folder_outlined,
        onPressed: () async {
          _onSelectItem(1);
        },
        isSelected: _handlingIsSelected(1),
      ),
      _BottomItem(
        tooltip: "Artists",
        iconSize: 20,
        iconSelected: Icons.person,
        iconUnSelected: Icons.person_outline,
        onPressed: () async {
          _onSelectItem(2);
        },
        isSelected: _handlingIsSelected(2),
      ),
    ];
    bottomOptions = <Widget>[];
    for (var i = 0; i < bottomItems.length; i++) {
      bottomOptions.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: bottomItems[i].onPressed,
              child: Container(
                width: 70,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: bottomItems[i].isSelected
                      ? accentColor.withAlpha(40)
                      : transparentColor,
                ),
                child: Icon(
                  bottomItems[i].isSelected
                      ? bottomItems[i].iconSelected
                      : bottomItems[i].iconUnSelected,
                  color: bottomItems[i].isSelected
                      ? MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? whiteColor
                          : accentColorBlend
                      : offGreyColor,
                  size: bottomItems[i].iconSize,
                ),
              ),
            ),
            bottomItems[i].isSelected
                ? Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      bottomItems[i].tooltip,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      );
    }
  }

  Future<List> getEverything() async {
    List<ArtistModel> artists = await queryController.getArtists();
    List<String> albums = await queryController.getFolders();
    List<SongModel> songs = await queryController.getSongs();
    return [artists, albums, songs];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final TextEditingController _textEditingController = TextEditingController();
  bool isSearch = false;
  List<SongModel> _defaultSongs = [];
  List<ArtistModel> _defaultArtists = [];
  List<String> _defaultFlders = [];
  List<SongModel> _searchSongs = [];
  List<ArtistModel> _searchArtists = [];
  List<String> _searchFlders = [];

  @override
  Widget build(BuildContext context) {
    initBottomItems();
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
        elevation: 0,
        toolbarHeight: 48,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25, top: 5),
          child: TextFormField(
            controller: _textEditingController,
            keyboardType: TextInputType.name,
            enableIMEPersonalizedLearning: true,
            onTap: () {
              setState(() {
                isSearch = true;
              });
            },
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _searchSongs = _defaultSongs
                      .where(
                        (element) => element.displayNameWOExt
                            .toLowerCase()
                            .contains(value),
                      )
                      .toList();
                  _searchArtists = _defaultArtists
                      .where(
                        (element) =>
                            element.artist.toLowerCase().contains(value),
                      )
                      .toList();
                  _searchFlders = _defaultFlders
                      .where(
                        (element) => element.toLowerCase().contains(value),
                      )
                      .toList();
                });
              } else {
                setState(() {
                  _searchSongs = _defaultSongs;
                  _searchArtists = _defaultArtists;
                  _searchFlders = _defaultFlders;
                });
              }
            },
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? blackColor
                      : whiteColor,
              hintText: 'Search Globally..',
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(),
              prefixIcon: IconButton(
                onPressed: () {},
                iconSize: 20,
                icon: Icon(
                  Icons.list_rounded,
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? greyColor
                      : offBlackColor,
                ),
              ),
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    isSearch = false;
                    _textEditingController.clear();
                  });
                },
                iconSize: 20,
                icon: Icon(
                  Icons.close,
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? greyColor
                      : offBlackColor,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? blackColor
                      : whiteColor,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        leadingWidth: MediaQuery.of(context).size.width - 75,
        actions: [
          InkWell(
            onTap: () async {
              await FileUploader().uploadFiles(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? whiteColor
                      : blackColor,
                  width: 2.0,
                ),
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? blackColor
                        : whiteColor,
              ),
              margin: const EdgeInsets.only(right: 20),
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/splash_screen/icon.png"),
              ),
            ),
          ),
        ],
      ),
      key: scaffoldState,
      body: FutureBuilder<List>(
        future: getEverything(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ArtistModel> artists = snapshot.data![0];
            List<String> folders = snapshot.data![1];
            List<SongModel> songs = snapshot.data![2];
            _defaultSongs = songs;
            _defaultArtists = artists;
            _defaultFlders = folders;

            if (isSearch) {
              songs = _searchSongs;
              artists = _searchArtists;
              folders = _searchFlders;
            }

            return Stack(
              children: [
                _BodySelection(
                  artists: artists,
                  songs: songs,
                  dir: widget.directory,
                  allDir: folders,
                  selectedIndex: _selectedIndex,
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Loading...",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                children: const [
                  Text(
                    "No Music Found",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Icon(Icons.music_off_outlined),
                ],
              ),
            );
          }
        },
      ),
      bottomSheet: StreamBuilder<CombinedAudioStream>(
        stream: combinedStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final combinedAudioStream = snapshot.data!;
            final processingState =
                combinedAudioStream.playerState.processingState;
            final playing = combinedAudioStream.playerState.playing;
            final currentIndex = combinedAudioStream.currentIndex;
            final songs = audioController.songs;
            if (playing ||
                processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering ||
                processingState == ProcessingState.ready) {
              return InkWell(
                onTap: () {
                  _bottomSheet(
                    songs,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? offBlackColor
                        : offWhiteColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Artwork
                        Hero(
                          tag: songs[currentIndex].id,
                          child: AudioQuery.offlineArtworkWidget(
                            id: songs[currentIndex].id,
                            fileName: songs[currentIndex].displayNameWOExt,
                            type: ArtworkType.AUDIO,
                            artworkType: ArtworkType.AUDIO,
                            borderRadius: BorderRadius.circular(10),
                            format: ArtworkFormat.PNG,
                            height: 50,
                            quality: 200,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        // Song Title and Artist
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 210,
                              child: Text(
                                songs[currentIndex].title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: 210,
                              child: Text(
                                songs[currentIndex].artist.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Share Button
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share,
                            color: accentColor,
                          ),
                        ),
                        if (playing)
                          IconButton(
                            onPressed: () {
                              audioController.player.pause();
                            },
                            icon: Icon(
                              Icons.play_arrow,
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? whiteColor
                                      : blackColor,
                            ),
                          )
                        else if (processingState != ProcessingState.completed)
                          IconButton(
                            onPressed: () {
                              audioController.player.play();
                            },
                            icon: Icon(
                              Icons.pause,
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? whiteColor
                                      : blackColor,
                            ),
                          )
                        else
                          IconButton(
                            onPressed: () {
                              audioController.player.pause();
                            },
                            icon: Icon(
                              Icons.play_arrow,
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? whiteColor
                                      : blackColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? blackColor
              : whiteColor,
          border: Border(
            top: BorderSide(
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? offGreyColor
                      : greyColor,
              width: 1.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: bottomOptions,
        ),
      ),
    );
  }

  void _bottomSheet(List<SongModel> songs) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      useSafeArea: true,
      builder: (context) => NowPlaying(song: songs),
    );
  }
}

/// Bottom Items
class _BottomItem {
  String tooltip;
  IconData iconSelected;
  IconData iconUnSelected;
  void Function()? onPressed;
  bool isSelected;
  double iconSize;

  _BottomItem(
      {required this.tooltip,
      required this.iconSelected,
      required this.iconUnSelected,
      this.onPressed,
      this.iconSize = 30,
      this.isSelected = false});
}

/// Body Selection form Bottom Navigation Bar
///
/// Chooses the page to be displayed
///
/// arguments:
///
/// [selectedIndex] : index of the selected item
///
/// [dir] : directory of the music
///
/// [songs] : list of songs
///
/// [allDir] : list of all directories
///
/// [artists] : list of all artists
///
class _BodySelection extends StatelessWidget {
  final int selectedIndex;
  final String dir;
  final List<SongModel> songs;
  final List<String> allDir;
  final List<ArtistModel> artists;

  const _BodySelection({
    Key? key,
    required this.selectedIndex,
    required this.dir,
    required this.songs,
    required this.allDir,
    required this.artists,
  }) : super(key: key);

  Widget _selectionPage(BuildContext context, int pos) {
    switch (pos) {
      case 0:
        return AllMusic(allSongs: songs);
      case 1:
        return AllFolder(
          paths: allDir,
        );

      case 2:
        return AllArtist(
          allArtist: artists,
        );

      default:
        return const Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => _selectionPage(context, selectedIndex),
    );
  }
}
