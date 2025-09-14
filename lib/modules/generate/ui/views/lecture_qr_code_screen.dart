import 'package:easyattend/core/themes/app_colors.dart';
import 'package:easyattend/core/themes/styles.dart';
import 'package:easyattend/core/utils/margins.dart';
import 'package:easyattend/core/widgets/background_scaffold.dart';
import 'package:easyattend/core/widgets/custom_icon_button.dart';
import 'package:easyattend/modules/generate/data/firebase/lectures_service.dart';
import 'package:easyattend/modules/generate/data/models/lecture.dart';
import 'package:easyattend/modules/generate/ui/widgets/rolling_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class LectureQrCodeScreen extends ConsumerStatefulWidget {
  const LectureQrCodeScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<LectureQrCodeScreen> createState() =>
      _LectureQrCodeScreenState();
}

class _LectureQrCodeScreenState extends ConsumerState<LectureQrCodeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lecturesService = ref.read(lecturesServiceProvider);

    return BackgroundScaffold(
      body: StreamBuilder<Lecture>(
        stream: lecturesService.getLectureStream(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lecture = snapshot.data!;
          final canCount = lecture.attendantsId.length > lecture.counter;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SafeArea(child: 0.h),
                Row(
                  children: [
                    CustomBackButton(),
                    24.w,
                    Text("QR Code", style: Styles.medium27),
                  ],
                ),
                24.h,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black25,
                        blurRadius: 11,
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                    color: const Color(0xFF3B3B3B).withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Lecture name:", style: Styles.medium20),
                      4.h,
                      Text(lecture.name),
                    ],
                  ),
                ),

                32.h,
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.primary, width: 4),
                  ),
                  child: PrettyQrView.data(
                    data: widget.id,
                    decoration: const PrettyQrDecoration(
                      background: Colors.white,
                      shape: PrettyQrSmoothSymbol(roundFactor: 0),
                    ),
                  ),
                ),
                32.h,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RollingCounter(
                      value: lecture.counter,
                      style: TextStyle(
                        fontFamily: GoogleFonts.notoSans().fontFamily,
                        fontSize: 60,
                      ),
                    ),
                    Text(
                      '  Registered / ',
                      style: Styles.medium16.copyWith(color: AppColors.primary),
                    ),
                    RollingCounter(
                      value: lecture.attendantsId.length,
                      style: TextStyle(
                        fontFamily: GoogleFonts.notoSans().fontFamily,
                        fontSize: 60,
                      ),
                    ),
                    Text(
                      '  Scanned',
                      style: Styles.medium16.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                24.h,
                Material(
                  color: Colors.white,
                  type: MaterialType.button,
                  borderRadius: BorderRadius.circular(13),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(13),
                    onTap:
                        canCount
                            ? () {
                              lecturesService.incrementRegisteredCounter(
                                widget.id,
                              );
                            }
                            : null,
                    child: Ink(
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color:
                            canCount
                                ? null
                                : const Color.fromARGB(255, 186, 186, 186),
                        gradient:
                            !canCount
                                ? null
                                : const LinearGradient(
                                  colors: [
                                    Color(0xFFE25619),
                                    Color(0xFFE92525),
                                  ],
                                ),
                      ),
                      child: Center(
                        child: Text(
                          "Register",
                          style: Styles.normal20.copyWith(
                            color: canCount ? null : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                24.h,
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity(vertical: -4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people_outline_outlined, color: Colors.white),
                      8.w,
                      Text("View Attendants", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
