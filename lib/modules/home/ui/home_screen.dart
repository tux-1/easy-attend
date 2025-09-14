import 'package:easyattend/core/themes/app_colors.dart';
import 'package:easyattend/core/widgets/background_scaffold.dart';
import 'package:easyattend/modules/generate/ui/views/generate_page.dart';
import 'package:easyattend/modules/history/ui/views/history_page.dart';
import 'package:easyattend/modules/home/ui/controllers/home_index_controller.dart';
import 'package:easyattend/modules/home/ui/widgets/home_bottom_nav_bar.dart';
import 'package:easyattend/modules/home/ui/widgets/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final controller = MobileScannerController(
    // required options for the scanner
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  // For zoom slider (0.0 to 1.0)
  double _zoomFactor = 0.0;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeIndex = ref.watch(homeIndexProvider);
    return BackgroundScaffold(
      bottomNavigationBar: HomeBottomNavBar(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: switch (homeIndex) {
        HomeIndex.generate => GeneratePage(),
        HomeIndex.history => HistoryPage(),
        HomeIndex.scan => Stack(
          children: [
            Positioned.fill(child: QrScanner(controller: controller)),
            // Top options bar
            SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: 16, left: 70, right: 70),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(blurRadius: 46, color: AppColors.black60),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        controller.value.torchState == TorchState.on
                            ? Icons.flash_off_outlined
                            : Icons.flash_on,
                        color: Colors.white,
                      ),
                      onPressed: ()async {
                        await controller.toggleTorch();
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.switch_camera,
                        color: Colors.white,
                      ),
                      onPressed: () => controller.switchCamera(),
                    ),
                  ],
                ),
              ),
            ),

            // Scanner frame overlay
            Center(
              child: CustomPaint(
                foregroundPainter: BorderPainter(),
                child: SizedBox(width: 250, height: 250),
              ),
            ),

            // Zoom slider
            Positioned(
              right: 0,
              left: 0,
              bottom: 185,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove, color: Colors.white),
                  SizedBox(
                    width: 300,
                    child: Slider(
                      value: _zoomFactor,
                      min: 0.0,
                      max: 1.0,

                      thumbColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() => _zoomFactor = value);
                        controller.setZoomScale(value);
                      },
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Icon(Icons.add, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      },
    );
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height;
    double sw = size.width;
    double cornerSide = sh * 0.1; // desirable value for corners side

    Paint paint =
        Paint()
          ..color = AppColors.primary
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    Path path =
        Path()
          ..moveTo(cornerSide, 0)
          ..quadraticBezierTo(0, 0, 0, cornerSide)
          ..moveTo(0, sh - cornerSide)
          ..quadraticBezierTo(0, sh, cornerSide, sh)
          ..moveTo(sw - cornerSide, sh)
          ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
          ..moveTo(sw, cornerSide)
          ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
