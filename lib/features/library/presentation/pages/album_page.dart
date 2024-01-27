import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simplemusicplayer/core/common/exports.dart';
import 'package:simplemusicplayer/features/library/presentation/cubit/library_state.dart';
import 'package:simplemusicplayer/features/library/presentation/cubit/libray_cubit.dart';
import 'package:simplemusicplayer/features/library/presentation/widgets/album_list_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
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
    if (state.category == 'Albums') {
      return const AlbumListPage();
    } else {
      return const SizedBox.shrink();
    }
  }
}
