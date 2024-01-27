import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simplemusicplayer/core/common/exports.dart';
import 'package:simplemusicplayer/features/library/presentation/cubit/library_state.dart';
import 'package:simplemusicplayer/features/library/presentation/cubit/libray_cubit.dart';
import 'package:simplemusicplayer/features/library/presentation/widgets/album_list_page.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
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
                _albums(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _albums(LibraryState state) {
    return const AlbumListPage();
  }
}
