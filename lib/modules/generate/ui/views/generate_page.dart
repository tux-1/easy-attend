import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyattend/core/router/app_router.dart';
import 'package:easyattend/core/themes/app_colors.dart';
import 'package:easyattend/core/themes/styles.dart';
import 'package:easyattend/core/utils/margins.dart';
import 'package:easyattend/core/widgets/custom_snack_bar.dart';
import 'package:easyattend/modules/generate/data/firebase/lectures_service.dart';
import 'package:easyattend/modules/home/ui/controllers/home_index_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class GeneratePage extends ConsumerStatefulWidget {
  const GeneratePage({super.key});

  @override
  ConsumerState<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends ConsumerState<GeneratePage> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SafeArea(bottom: false, child: SizedBox()),

          Align(
            alignment: AlignmentDirectional.topStart,
            child: Text("Generate", style: Styles.medium27),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 44),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.black25,
                  blurRadius: 11,
                  blurStyle: BlurStyle.outer,
                ),
              ],
              color: Color(0xFF3B3B3B).withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(4),
              border: Border(
                top: BorderSide(color: AppColors.primary, width: 2),
                bottom: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo_big.png',
                    height: 49,
                    width: 49,
                    cacheHeight: 49,
                    cacheWidth: 49,
                  ),
                ),
                24.h,
                Text("Lecture Name", style: Styles.normal16),
                8.h,
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: controller,
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter lecture name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(hintText: 'Enter lecture name'),
                  ),
                ),
                48.h,
                Center(
                  child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _isLoading
                              ? null
                              : () async {
                                if (formKey.currentState?.validate() != true) {
                                  return;
                                }

                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  LocationPermission permission =
                                      await Geolocator.checkPermission();

                                  if (permission == LocationPermission.denied) {
                                    permission =
                                        await Geolocator.requestPermission();
                                  }

                                  if (permission == LocationPermission.always ||
                                      permission ==
                                          LocationPermission.whileInUse) {
                                    final position =
                                        await Geolocator.getCurrentPosition();

                                    final GeoPoint geoPoint = GeoPoint(
                                      position.latitude,
                                      position.longitude,
                                    );

                                    final qrCode = await ref
                                        .read(lecturesServiceProvider)
                                        .generateLecture(
                                          name: controller.text,
                                          userLocation: geoPoint,
                                        );

                                    if (mounted) {
                                      context.pushNamed(
                                        AppRoutes.lectureQrCode,
                                        pathParameters: {'id': qrCode},
                                      );
                                      ref
                                          .read(homeIndexProvider.notifier)
                                          .setIndex(HomeIndex.history);
                                    }
                                  } else {
                                    Geolocator.openLocationSettings();
                                  }
                                } catch (e) {
                                  // Show error snackbar
                                  if (mounted) {
                                    CustomSnackBar.show(
                                      context: context,
                                      message:
                                          'Error generating QR code: ${e.toString()}',
                                      type: SnackBarType.error,
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text("Generate QR Code"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
