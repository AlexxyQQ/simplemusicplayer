// Please Do Not Steal
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicplayer/components/bottom_nav.dart';
import 'package:musicplayer/constants/colors.dart';
import 'package:musicplayer/view/onBoardingPage/on_boarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true; // Enable dithering for better quality
  // Initialize JustAudioBackground

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'musicplayer',
    androidNotificationOngoing: true,
    androidShowNotificationBadge: true,
    notificationColor: accentColor2,
    preloadArtwork: true,
  );
  // Initialize Hive
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await Hive.initFlutter('musicplayer');
  } else {
    await Hive.initFlutter();
  }

  // Open Hive Boxes
  await hiveOpen('settings');
  await hiveOpen('user');
  await hiveOpen('uploads');
  await hiveOpen('songs');

  runApp(
    const MyApp(),
  );
}

/// Open Hive Boxes
/// Provide a box name to open, if it fails to open, it will try again
Future<void> hiveOpen(String boxName) async {
  await Hive.openBox(boxName).onError(
    (error, stackTrace) async {
      await Hive.openBox(boxName);
      throw 'Failed to open $boxName Box\nError: $error';
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Check if it is the first time the app is opened
  Widget initalPage() {
    return Hive.box('settings').get('isFirstTime') != null
        ? const BottomNav()
        : const OnBoardingPage();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "musicplayer",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Sans',
        useMaterial3: true, // Enable Material 3
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: blackColor,
              displayColor: blackColor,
            ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Sans',
        useMaterial3: true, // Enable Material 3
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: whiteColor,
              displayColor: whiteColor,
            ),
      ),
      routes: {
        '/': (context) => initalPage(),
        '/library': (context) => const BottomNav(),
        '/onBoarding': (context) => const OnBoardingPage(),
        '/nowPlaying': (context) => const BottomNav(),
      },
      navigatorKey: navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/library') {
          return MaterialPageRoute(
            builder: (context) => const BottomNav(),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}
