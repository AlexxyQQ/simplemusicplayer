import 'package:simplemusicplayer/core/common/exports.dart';
import 'package:simplemusicplayer/features/library/presentation/cubit/library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit() : super(LibraryState.initial());

  void selectCategory(String category) {
    emit(state.copyWith(category: category));
  }
}
