import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simplemusicplayer/core/common/exports.dart';
import 'package:simplemusicplayer/features/library/presentation/cubit/library_state.dart';
import 'package:simplemusicplayer/features/library/presentation/cubit/libray_cubit.dart';
import 'package:simplemusicplayer/features/library/presentation/widgets/artist_list_page.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
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
                _artists(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _artists(LibraryState state) {
    return const ArtistListPage();
  }
}
