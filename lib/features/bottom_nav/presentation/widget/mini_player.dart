import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simplemusicplayer/config/constants/global_constants.dart';
import 'package:simplemusicplayer/core/common/exports.dart';
import 'package:simplemusicplayer/features/bottom_nav/presentation/widget/duration_slider.dart';
import 'package:simplemusicplayer/features/home/presentation/widgets/method/extract_album_cover_color.dart';
import 'package:simplemusicplayer/features/now_playing/presentation/cubit/now_playing_state.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  Color albumArtColor = PrimitiveColors.grey900;
  Color textColor = AppDarkColor.onSurface;

  @override
  void initState() {
    super.initState();
  }

  void getAlbumArtColor(String filePath) async {
    extractAlbumArtColor(filePath).then((value) {
      setState(() {
        albumArtColor = value[0];
        textColor = value[1];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingCubit, NowPlayingState>(
      builder: (context, state) {
        if (state.currentSong == null) {
          return Container();
        }

        getAlbumArtColor(state.currentSong!.albumArt ?? "null");

        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.nowPlayingRoute);
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 10.w,
            height: 60.h,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: albumArtColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Stack(
              children: [
                // Content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cover and Name
                      Row(
                        children: [
                          // Album Cover
                          Hero(
                            tag: 'NowPlayingAlbumArt',
                            child: Container(
                              height: 44.h,
                              width: 44.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                image: DecorationImage(
                                  image: Image.file(
                                    File(state.currentSong!.albumArt ?? ''),
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/splash_screen/icon.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ).image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          //  Song Title
                          SizedBox(
                            width: 150.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  state.currentSong!.title,
                                  style:
                                      Theme.of(context).textTheme.mBS.copyWith(
                                            color: textColor,
                                            letterSpacing: 0.8,
                                          ),
                                ),
                                Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "${state.currentSong!.artist}",
                                  style:
                                      Theme.of(context).textTheme.lC.copyWith(
                                            color: textColor,
                                            letterSpacing: 1,
                                          ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Icons
                      Row(
                        children: [
                          // Play
                          IconButton(
                            onPressed: () {
                              if (state.isPlaying) {
                                context.read<NowPlayingCubit>().pause();
                              } else {
                                context.read<NowPlayingCubit>().play();
                              }
                            },
                            icon: SvgPicture.asset(
                              state.isPlaying
                                  ? AppIcons.playOutlined
                                  : AppIcons.pause,
                              color: textColor,
                              height: 18.r,
                            ),
                          ),
                          // Next
                          IconButton(
                            onPressed: () {
                              context.read<NowPlayingCubit>().next();
                              BlocProvider.of<QueryCubit>(context)
                                  .updateRecentlyPlayedSongs(
                                song: state.currentSong!,
                              );
                            },
                            icon: SvgPicture.asset(
                              AppIcons.nextOutlined,
                              color: textColor,
                              height: 18.r,
                            ),
                          ),
                          // Share
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<NowPlayingCubit>(context)
                                  .favouriteSong(
                                song: state.currentSong!,
                                context: context,
                              );
                            },
                            icon: SvgPicture.asset(
                              state.currentSong!.isFavorite
                                  ? AppIcons.heartFilled
                                  : AppIcons.heartOutlined,
                              color: textColor,
                              height: 18.r,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //Prograss Bar
                Positioned(
                  bottom: -18.h,
                  left: -20.w,
                  width: 416.w,
                  child: DurationSlider(
                    height: 6.h,
                    thumbRadius: 0,
                    overlayRadius: 20.r,
                    audioPlayer: state.audioPlayer!,
                    duration: false,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
