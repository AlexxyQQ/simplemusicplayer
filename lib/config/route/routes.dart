import 'package:flutter/material.dart';
import 'package:simplemusicplayer/features/bottom_nav/presentation/page/bottom_navigation.dart';
import 'package:simplemusicplayer/features/home/presentation/widgets/folder_page.dart';
import 'package:simplemusicplayer/features/now_playing/presentation/page/now_playing_page.dart';

import '../../core/common/no_page_route.dart';
import '../../features/onboarding/presentation/view/on_boarding_page.dart';
import '../../features/splash/presentation/view/splashscreen.dart';

class AppRoutes {
  static const String initialRoute = '/';
  static const String bottomNavRoute = '/bottomNav';
  static const String getStartedRoute = '/welcome';
  static const String onBoardingRoute = '/onBoarding';
  static const String nowPlayingRoute = '/nowPlaying';
  static const String settingRoute = '/settings';
  static const String manageAllSongsRoute = '/manageAllSongs';
  static const String manageAllPublicSongsRoute = '/manageAllPublicSongs';
  static const String folderPageRoute = '/folderPage';

  static final Map<String, Widget Function(BuildContext)> appPageRoutes = {
    // Starters
    initialRoute: (context) => const SplashScreen(),
    onBoardingRoute: (context) => const OnBoardingPage(),
    // Home
    bottomNavRoute: (context) => const BottomNavigationScreen(),
    folderPageRoute: (context) => const FolderPage(),
    nowPlayingRoute: (context) => const NowPlayingPage(),
    // Settings
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // If the named route is not defined, go to the default page
    return MaterialPageRoute(
      builder: (context) => const NoRoutePage(),
    );
  }
}
