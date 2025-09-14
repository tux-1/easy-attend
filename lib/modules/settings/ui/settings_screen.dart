import 'package:easyattend/core/router/app_router.dart';
import 'package:easyattend/core/themes/app_colors.dart';
import 'package:easyattend/core/themes/styles.dart';
import 'package:easyattend/core/utils/margins.dart';
import 'package:easyattend/core/widgets/background_scaffold.dart';
import 'package:easyattend/core/widgets/custom_icon_button.dart';
import 'package:easyattend/modules/history/ui/controllers/history_providers.dart';
import 'package:easyattend/modules/home/ui/controllers/home_index_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SafeArea(bottom: false, child: SizedBox()),

            CustomBackButton(),
            32.h,
            Text(
              "Settings",
              style: Styles.medium27.copyWith(color: AppColors.primary),
            ),
            24.h,
            MaterialButton(
              onPressed: () {},
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.zero,
              color: AppColors.background,
              elevation: 6,
              child: Ink(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: FittedBox(
                        child: Icon(Icons.person, color: AppColors.primary),
                      ),
                    ),
                    12.w,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Info",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.15,
                          ),
                        ),
                        4.h,
                        Text(
                          "Profile page and user details.",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            16.h,
            Consumer(
              builder: (context, ref, child) {
                return MaterialButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    ref.invalidate(homeIndexProvider);
                    ref.invalidate(scannedHistoryProvider);
                    ref.invalidate(createdHistoryProvider);

                    context.go(AppRoutes.getStarted);
                  },
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero,
                  color: AppColors.background,
                  elevation: 6,
                  child: Ink(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 32,
                          width: 32,
                          child: FittedBox(
                            child: Icon(
                              Icons.logout_outlined,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        12.w,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Log Out",
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.15,
                              ),
                            ),
                            4.h,
                            Text(
                              "See you soon.",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
