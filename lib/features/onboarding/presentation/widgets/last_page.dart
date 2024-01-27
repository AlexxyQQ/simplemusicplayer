import 'package:flutter/material.dart';
import 'package:simplemusicplayer/config/constants/colors/app_colors.dart';
import 'package:simplemusicplayer/config/constants/colors/primitive_colors.dart';
import 'package:simplemusicplayer/config/route/routes.dart';
import 'package:simplemusicplayer/core/utils/extensions/app_text_theme_extension.dart';


class LastPage extends StatelessWidget {
  const LastPage({
    super.key,
    required this.mediaQuerySize,
    required this.changeLoading,
  });
  final Size mediaQuerySize;
  final Function(bool value) changeLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Terms and Conditions
        Text(
          "By continuing, you’re agreeing to \n simplemusicplayer Privacy policy and Terms of use.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.lC.copyWith(
                color: AppColors().onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 20),

        // Get Started Online
        InkWell(
          onTap: () async {
            final navigator = Navigator.of(context);
            navigator.pushNamedAndRemoveUntil(
              AppRoutes.bottomNavRoute,
              (route) => false,
            );
          },
          child: Container(
            height: 67,
            width: mediaQuerySize.width,
            decoration: const BoxDecoration(
              color: PrimitiveColors.primary500,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Get Started Now',
                  style: Theme.of(context)
                      .textTheme
                      .h4
                      .copyWith(color: AppLightColor.onBackground),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
