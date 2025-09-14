import 'package:easyattend/core/themes/app_colors.dart';
import 'package:easyattend/core/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';

class DeleteLectureDialog extends StatefulWidget {
  final String lectureName;
  final Future<bool> Function() onDelete;

  const DeleteLectureDialog({
    super.key,
    required this.lectureName,
    required this.onDelete,
  });

  @override
  State<DeleteLectureDialog> createState() => _DeleteLectureDialogState();
}

class _DeleteLectureDialogState extends State<DeleteLectureDialog> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Lecture'),
      backgroundColor: AppColors.background,
      content: Text(
        'Are you sure you want to delete "${widget.lectureName}"?'
        '\nThis action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed:
              _isDeleting ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              _isDeleting
                  ? null
                  : () async {
                    setState(() {
                      _isDeleting = true;
                    });

                    try {
                      final success = await widget.onDelete();
                      if (mounted) {
                        Navigator.of(context).pop(success);
                      }
                    } catch (e) {
                      if (mounted) {
                        Navigator.of(context).pop(false);
                        CustomSnackBar.show(
                          context: context,
                          message: e.toString(),
                          type: SnackBarType.error,
                        );
                      }
                    }
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 196, 46, 36),
          ),
          child:
              _isDeleting
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Text('Delete'),
        ),
      ],
    );
  }
}
