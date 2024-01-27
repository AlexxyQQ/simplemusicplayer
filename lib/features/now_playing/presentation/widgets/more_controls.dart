import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplemusicplayer/config/constants/global_constants.dart';
import 'package:simplemusicplayer/core/common/exports.dart';

class MoreControls extends StatelessWidget {
  const MoreControls({
    super.key,
    required this.setScroll,
  });
  final void Function() setScroll;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //? Currently Playing Device
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.devices,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              'Living Room',
              style: Theme.of(context).textTheme.mBS.copyWith(
                    color: PrimitiveColors.primary500,
                    letterSpacing: 1,
                  ),
            ),
          ],
        ),
        //? Favorite and Queue
        Row(
          children: [
            //? Favorite
            IconButton(
              onPressed: () {
                BlocProvider.of<NowPlayingCubit>(context).favouriteSong(
                  song: BlocProvider.of<NowPlayingCubit>(context)
                      .state
                      .currentSong!,
                  context: context,
                );
              },
              icon: SvgPicture.asset(
                BlocProvider.of<NowPlayingCubit>(context)
                        .state
                        .currentSong!
                        .isFavorite
                    ? AppIcons.heartFilled
                    : AppIcons.heartOutlined,
                color: AppColors().onBackground,
                height: 18.r,
              ),
            ),
            SizedBox(width: 4.w),
            IconButton(
              onPressed: () {
                setScroll();
              },
              icon: const Icon(
                Icons.queue_music,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
