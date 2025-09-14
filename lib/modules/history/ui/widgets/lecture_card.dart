
import 'package:easyattend/core/router/app_router.dart';
import 'package:easyattend/core/themes/app_colors.dart';
import 'package:easyattend/core/themes/styles.dart';
import 'package:easyattend/core/utils/margins.dart';
import 'package:easyattend/core/widgets/custom_snack_bar.dart';
import 'package:easyattend/modules/generate/data/models/lecture.dart';
import 'package:easyattend/modules/history/data/firebase/history_service.dart';
import 'package:easyattend/modules/history/ui/widgets/delete_lecture_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LectureCard extends ConsumerWidget {
  final Lecture lecture;
  final bool isCreated;

  const LectureCard({
    super.key,
    required this.lecture,
    required this.isCreated,
  });

  String _formatDate(DateTime timestamp) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    return dateFormat.format(timestamp);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = lecture.ownerId == currentUserId;

    return GestureDetector(
      onTap: isCreated
          ? () {
              context.pushNamed(
                AppRoutes.lectureQrCode,
                pathParameters: {'id': lecture.id},
              );
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.9676),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: AppColors.black25,
              offset: const Offset(0, 4),
              blurRadius: 4,
              blurStyle: BlurStyle.outer,
            ),
            BoxShadow(
              color: AppColors.black25,
              blurRadius: 11,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_big.png',
                  height: 43,
                  width: 43,
                ),
                12.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lecture.name, style: Styles.medium16),
                      8.h,
                      Text(
                        _formatDate(lecture.date),
                        style: Styles.normal14.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (isOwner && isCreated)
                  IconButton( 
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _showDeleteDialog(context, ref),
                    tooltip: 'Delete Lecture',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            16.h,
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 16,
                  color: AppColors.grey,
                ),
                8.w,
                Text(
                  "${lecture.attendantsId.length} attendees",
                  style: Styles.normal12.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteLectureDialog(
        lectureName: lecture.name,
        onDelete: () async {
          return await ref.read(historyServiceProvider).deleteLecture(lecture.id);
        },
      ),
    );

    if (result == true && context.mounted) {
      CustomSnackBar.show(
        context: context,
        message: 'Lecture deleted successfully',
        type: SnackBarType.success,
      );
    }
  }
}