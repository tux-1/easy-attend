import 'package:easyattend/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class BackgroundScaffold extends StatelessWidget {
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomSheet;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool? extendBody;
  final bool? extendBodyBehindAppBar;
  final double circleSize;

  const BackgroundScaffold({
    super.key,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.extendBody,
    this.extendBodyBehindAppBar,
    this.circleSize = 418,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomSheet: bottomSheet,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      extendBody: extendBody ?? false,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Your original background circles (unchanged)
          Positioned(
            top: -44,
            right: -circleSize / 4,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.backgroundCircleColor.withValues(alpha: 0.2),
                border: Border.all(
                  color: AppColors.backgroundCircleBorder.withValues(
                    alpha: 0.2,
                  ),
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                ),
              ),
              child: Center(
                child: Container(
                  width: circleSize / 2,
                  height: circleSize / 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.backgroundCircleColor.withValues(
                      alpha: 0.21,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: circleSize * 1.2,
            left: -262,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.backgroundCircleColor.withValues(alpha: 0.2),
                border: Border.all(
                  color: AppColors.backgroundCircleBorder.withValues(
                    alpha: 0.2,
                  ),
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                ),
              ),
              child: Center(
                child: Container(
                  width: circleSize / 2,
                  height: circleSize / 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.backgroundCircleColor.withValues(
                      alpha: 0.21,
                    ),
                  ),
                ),
              ),
            ),
          ),
          MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: Positioned(
              bottom: 0,
              left: circleSize * 0.6,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.backgroundCircleColor.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
          // Main content
          body ?? const SizedBox(),
        ],
      ),
    );
  }
}
