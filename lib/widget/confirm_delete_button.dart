import 'package:flutter/material.dart';
import 'package:giao_dien_1/config/default.dart';

/// HỘP THOẠI XÁC NHẬN XÓA DÙNG CHUNG

Future<bool> showConfirmDeleteDialog(BuildContext context) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      actionsAlignment: MainAxisAlignment.end,
      title: const Text(
        'Bạn có chắc không?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: 'Inter',
        ),
      ),
      content: const Text(
        'Dữ liệu này có thể bị xóa',
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Inter',
          color: Colors.black87,
        ),
      ),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Hủy'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            elevation: 0,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Xóa',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );

  return confirm == true;
}

/// CONFIRM DELETE BUTTON

class ConfirmDeleteButton extends StatelessWidget {
  final Future<void> Function() onConfirmDelete;
  final String label;
  final String successTitle;
  final String successMessage;
  final VoidCallback? onSuccessClose;

  const ConfirmDeleteButton({
    super.key,
    required this.onConfirmDelete,
    this.label = 'Xóa',
    required this.successTitle,
    required this.successMessage,
    this.onSuccessClose,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: () async {
          final confirm = await showConfirmDeleteDialog(context);

          if (confirm == true) {
            await onConfirmDelete();

            if (!context.mounted) return;

            await showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                titlePadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                actionsPadding: const EdgeInsets.fromLTRB(24, 24, 16, 16), 
                actionsAlignment: MainAxisAlignment.end,
                title: Text(
                  successTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                ),
                content: Text(
                  successMessage,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    color: Colors.black87,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: onSuccessClose ??
                        () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Đóng',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          side: const BorderSide(
            color: AppColors.mainOrange,
            width: 1.2,
          ),
          elevation: 3,
          shadowColor: AppColors.mainOrange.withOpacity(0.2),
        ).copyWith(
          overlayColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
          surfaceTintColor: MaterialStateProperty.all(
            Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.delete,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}