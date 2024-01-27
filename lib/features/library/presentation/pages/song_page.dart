import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simplemusicplayer/core/common/exports.dart';
import 'package:simplemusicplayer/features/home/domain/entity/song_entity.dart';
import 'package:simplemusicplayer/features/home/presentation/widgets/song_list_page.dart';
import 'package:simplemusicplayer/features/library/presentation/cubit/library_state.dart';
import 'package:simplemusicplayer/features/library/presentation/cubit/libray_cubit.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryCubit, LibraryState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // List of songs
                _songs(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _songs(LibraryState state) {
    if (state.category == 'Songs') {
      final List<SongEntity> songs =
          BlocProvider.of<QueryCubit>(context).state.songs;

      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 50.h,
        child: SongsListPage(
          appbar: false,
          borderRadius: 12.r,
          coverHeight: 50.h,
          coverWidth: 50.w,
          songs: songs,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
