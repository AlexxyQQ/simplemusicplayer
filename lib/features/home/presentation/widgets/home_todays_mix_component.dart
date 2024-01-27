import 'package:flutter_svg/svg.dart';
import 'package:simplemusicplayer/config/constants/global_constants.dart';
import 'package:simplemusicplayer/core/common/album_query_widget.dart';
import 'package:simplemusicplayer/core/common/exports.dart';
import 'package:simplemusicplayer/features/home/presentation/cubit/home_state.dart';
import 'package:simplemusicplayer/features/home/presentation/widgets/song_list_page.dart';
import 'package:shimmer/shimmer.dart';

class HomeTodaysMixComponent extends StatelessWidget {
  const HomeTodaysMixComponent({
    super.key,
  });

  Widget _buildShimmerEffect(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors(inverseDarkMode: true).surfaceDim,
      highlightColor: AppColors(inverseDarkMode: true).surfaceContainerHigh,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Number of shimmer items you want to show
        itemBuilder: (_, __) => Container(
          height: 180,
          width: 180,
          margin: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
          child: Stack(
            children: [
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  height: 115,
                  width: 165,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors(inverseDarkMode: true)
                        .surfaceDim
                        .withOpacity(0.5),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  height: 90,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 180,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors(inverseDarkMode: true)
                              .surfaceContainerLowest
                              .withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors(inverseDarkMode: true)
                              .surfaceContainerLowest
                              .withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QueryCubit, HomeState>(
      builder: (context, state) {
        return BlocBuilder<QueryCubit, HomeState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const SizedBox.shrink();
            } else if (state.isSuccess) {
              if (state.albums.isEmpty) {
                return const SizedBox.shrink();
              } else {
                return Column(
                  children: [
                    // Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Favourite Songs",
                          style: Theme.of(context).textTheme.h5.copyWith(
                                color: AppColors().onBackground,
                              ),
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Go to all folders page
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    // List Section
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // only show 10 items
                        itemCount: state.favouriteSongs!.length > 10
                            ? 10
                            : state.favouriteSongs!.length,
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SongsListPage(
                                    songs: state.albums[index].songs ?? [],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 300,
                              width: 180,
                              alignment: Alignment.bottomLeft,
                              margin: const EdgeInsets.only(
                                bottom: 8,
                                right: 8,
                                left: 8,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Album Cover
                                  Stack(
                                    children: [
                                      SongArtWork(
                                        song: state.favouriteSongs![index],
                                        height: 110,
                                        width: 180,
                                        borderRadius: 8,
                                      ),
                                      // simplemusicplayer Logo
                                      Positioned(
                                        top: 4,
                                        left: 4,
                                        child: SvgPicture.asset(
                                          AppIcons.logo,
                                          color: AppColors().primary,
                                          height: 12,
                                          width: 12,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        child: Container(
                                          height: 4,
                                          width: 180,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(500),
                                            color: PrimitiveColors.primary200,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Album Details
                                  Text(
                                    "${state.favouriteSongs?[index].title}",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .lBS
                                        .copyWith(
                                          color: AppColors().onBackground,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              }
            } else {
              return const Center(
                child: Text('No data'),
              );
            }
          },
        );
      },
    );
  }
}
