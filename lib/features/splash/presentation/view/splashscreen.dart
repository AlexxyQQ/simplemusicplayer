
import 'package:flutter/material.dart';
import 'package:simplemusicplayer/config/route/routes.dart';
import 'package:simplemusicplayer/core/common/hive/hive_service/setting_hive_service.dart';
import 'package:simplemusicplayer/core/common/static_loader.dart';
import 'package:simplemusicplayer/injection/app_injection_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _zoomAnimationController;
  Animation<double>? _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    init();
  }

  void _initAnimations() {
    _zoomAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _zoomAnimation =
        Tween<double>(begin: 1.0, end: 1.5).animate(_zoomAnimationController!);

    // Start animation after 1 second
    Future.delayed(const Duration(milliseconds: 1000), () {
      _zoomAnimationController!.forward();
    });
  }

  @override
  void dispose() {
    _zoomAnimationController?.dispose();
    super.dispose();
  }

  init() async {
    final nav = Navigator.of(context);

    final settings = await get<SettingsHiveService>().getSettings();

    if (settings.firstTime) {
      nav.pushNamed(AppRoutes.onBoardingRoute);
    } else {
      nav.pushNamed(AppRoutes.bottomNavRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Loader(),
      ),
    );
  }
}
