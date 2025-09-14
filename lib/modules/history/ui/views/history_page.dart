import 'package:easyattend/core/router/app_router.dart';
import 'package:easyattend/core/widgets/custom_icon_button.dart';
import 'package:easyattend/modules/generate/data/models/lecture.dart';
import 'package:easyattend/modules/history/ui/controllers/history_providers.dart';
import 'package:easyattend/modules/history/ui/widgets/lecture_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easyattend/core/themes/app_colors.dart';
import 'package:easyattend/core/themes/styles.dart';
import 'package:easyattend/core/utils/margins.dart';
import 'package:go_router/go_router.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryPage> {
  bool _showScanned = true; // true for scanned, false for created

  @override
  Widget build(BuildContext context) {
    ref.watch(createdHistoryProvider);
    ref.watch(scannedHistoryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SafeArea(bottom: false, child: SizedBox()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Row(
            children: [
              Text("History", style: Styles.medium27),
              Spacer(),
              CustomIconButton(
                icon: Icon(Icons.menu, color: AppColors.primary),
                onTap: () {
                  context.push(AppRoutes.settingsScreen);
                },
              ),
            ],
          ),
        ),
        24.h,
        _buildTabBar(),
        32.h,
        Expanded(
          child: _showScanned ? _buildScannedList() : _buildCreatedList(),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.all(2),
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [BoxShadow(blurRadius: 11, color: AppColors.black25)],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showScanned = true),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient:
                      _showScanned
                          ? LinearGradient(
                            colors: [Color(0xFFE25619), Color(0xFFE92525)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                          : null,
                ),
                child: Center(child: Text('Scanned', style: Styles.medium17)),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showScanned = false),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient:
                      !_showScanned
                          ? LinearGradient(
                            colors: [Color(0xFFE25619), Color(0xFFE92525)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                          : null,
                ),
                child: Center(child: Text('Created', style: Styles.medium17)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannedList() {
    final scannedLectures = ref.watch(scannedHistoryProvider);

    return scannedLectures.when(
      data: (lectures) => _buildLecturesList(lectures),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildCreatedList() {
    final createdLectures = ref.watch(createdHistoryProvider);

    return createdLectures.when(
      data: (lectures) => _buildLecturesList(lectures),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildLecturesList(List<Lecture> lectures) {
    if (lectures.isEmpty) {
      return Column(
        children: [
          Spacer(),
          Center(child: Text('No lectures found', style: Styles.medium18)),
          Spacer(flex: 2),
        ],
      );
    }

    return ListView.builder(
      itemCount: lectures.length + 1,
      padding: const EdgeInsets.only(left: 24, right: 24),

      itemBuilder: (context, index) {
        if (index == lectures.length) {
          return 124.h;
        } else {
          final lecture = lectures[index];

          return LectureCard(lecture: lecture, isCreated: !_showScanned);
        }
      },
    );
  }
}
