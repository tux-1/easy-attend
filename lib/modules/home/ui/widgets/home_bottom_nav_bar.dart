import 'package:easyattend/core/themes/app_colors.dart';
import 'package:easyattend/core/themes/styles.dart';
import 'package:easyattend/core/utils/margins.dart';
import 'package:easyattend/modules/home/ui/controllers/home_index_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomeBottomNavBar extends ConsumerWidget {
  const HomeBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(homeIndexProvider.notifier);
    final state = ref.watch(homeIndexProvider);

    Color colorFromHomeIndex(HomeIndex index) {
      if (index == state) {
        return AppColors.primary;
      } else {
        return AppColors.lightSilver;
      }
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30),
            Container(
              height: 70,
              margin: EdgeInsets.only(left: 35, right: 35, bottom: 25),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(blurRadius: 46, color: AppColors.black60),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      notifier.setIndex(HomeIndex.generate);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code_2_outlined,
                          color: colorFromHomeIndex(HomeIndex.generate),
                        ),
                        Text(
                          "Generate",
                          style: Styles.medium17.copyWith(
                            color: colorFromHomeIndex(HomeIndex.generate),
                          ),
                        ),
                      ],
                    ),
                  ),
                  0.h,
                  InkWell(
                    onTap: () {
                      notifier.setIndex(HomeIndex.history);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.history,
                          color: colorFromHomeIndex(HomeIndex.history),
                        ),
                        Text(
                          "History",
                          style: Styles.medium17.copyWith(
                            color: colorFromHomeIndex(HomeIndex.history),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  notifier.setIndex(HomeIndex.scan);
                },
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary,
                        blurStyle: BlurStyle.outer,
                        blurRadius: 21,
                      ),
                    ],
                  ),
                  child: InkWell(
                    child: Center(
                      child: SvgPicture.asset("assets/svgs/scan.svg"),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
