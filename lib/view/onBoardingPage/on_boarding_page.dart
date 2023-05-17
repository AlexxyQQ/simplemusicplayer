import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/components/bottom_nav.dart';
import 'package:musicplayer/components/custom_page_indicator.dart';
import 'package:musicplayer/constants/colors.dart';
import 'package:musicplayer/constants/text_style.dart';
import 'package:musicplayer/controllers/query_audio.dart';
import 'package:musicplayer/view/onBoardingPage/page_builder.dart';
import 'package:permission_handler/permission_handler.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  static PageController controller = PageController();
  bool isLastPage = false;
  List<dynamic> pages = const [
    OnBoardPageBuilder(
      color: Color(0xffceeaca),
      lottieUrl: 'assets/lottie/4879-trumpet-music.json',
      title: 'Welcome to musicplayer',
      subtitle:
          'Seamlessly switch between your computer and phone without missing a beat.',
    ),
    OnBoardPageBuilder(
      color: Color(0xffd6c4ee),
      lottieUrl: 'assets/lottie/31634-turn-music-into-audience.json',
      title: 'Listen to you library offline',
      subtitle:
          'musicplayer support playing offline media saved in you device or from the internet.',
    ),
    OnBoardPageBuilder(
        color: Color(0xFF9EBB8E),
        lottieUrl:
            'assets/lottie/139537-boy-avatar-listening-music-animation.json',
        title: 'Get started now!!',
        subtitle:
            "Login to get started, if you don\'t have an account, you can create one."),
  ];

  Future<void> permission() async {
    var perm = await Permission.storage.status;
    if (perm.isDenied) {
      await Permission.storage.request();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 2;
              });
            },
            scrollDirection: Axis.horizontal,
            reverse: false,
            physics: const BouncingScrollPhysics(),
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return pages[index];
            },
          ),
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/splash_screen/Logo.png'),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'musicplayer',
                      style: textStyle(
                        family: 'Sans',
                        fontSize: 23,
                        color: blackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomPageIndicator(
                  controller: controller,
                  itemCount: 3,
                  dotWidth: 50,
                  dotHeight: 10,
                  dotSpacing: 15,
                  trailing: true,
                  activeColor: accentColor,
                  inactiveColor: greyColor,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: isLastPage
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 0),
                    child: TextButton(
                      onPressed: () async {
                        await Hive.box('settings').put('isFirstTime', false);
                        await AudioQuery().requestPermission();
                        await permission();
                        Get.to(
                          () => const BottomNav(),
                          transition: Transition.native,
                          duration: const Duration(milliseconds: 200),
                        );
                      },
                      child: Text(
                        'Get Started Offline',
                        style: textStyle(
                          family: 'Sans',
                          fontSize: 20,
                          color: blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: blackColor,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () {
                            controller.nextPage(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.linearToEaseOut);
                          },
                          child: Text(
                            'Next',
                            style: textStyle(
                              family: 'Sans',
                              fontSize: 20,
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: blackColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: transparentColor,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () {
                            controller.animateToPage(3,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeInOut);
                          },
                          child: Text(
                            'Skip',
                            style: textStyle(
                              family: 'Sans',
                              fontSize: 20,
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          "By continuing, you’re agreeing to musicplayer Privacy policy and Term of use.",
                          style: textStyle(
                            family: 'Sans',
                            fontSize: 12,
                            color: offBlackColor,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
