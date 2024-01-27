import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemusicplayer/features/home/presentation/cubit/query_cubit.dart';
import 'package:simplemusicplayer/features/library/presentation/cubit/libray_cubit.dart';
import 'package:simplemusicplayer/features/now_playing/presentation/cubit/now_playing_cubit.dart';

import '../../injection/app_injection_container.dart';

class BlocProvidersList {
  static final blocList = [
    BlocProvider<QueryCubit>(create: (context) => get()),
    BlocProvider<LibraryCubit>(create: (context) => get()),
    BlocProvider<NowPlayingCubit>(create: (context) => get()),
  ];
}
