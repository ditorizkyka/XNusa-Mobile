import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/constant/constant.dart';

void showChooseButtonDialog({
  String? cancelText,
  String? confirmText,
  required String title,
  required String description,
  required VoidCallback onDiscard,
  required Future<void> Function() onSave,
  String discardText = "Discard",
  String saveText = "Save & Continue",
  bool barrierDismissible = true,
}) {
  Get.dialog(
    AlertDialog(
      alignment: Alignment.center,
      backgroundColor: ColorApp.white,
      title: Text(
        title,
        style: TypographyApp.headline1.copyWith(fontSize: SizeApp.h16),
        textAlign: TextAlign.center,
      ),
      content: Text(
        description,
        style: TypographyApp.label.copyWith(
          fontWeight: FontWeight.w200,
          color: ColorApp.darkGrey,
        ),
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: onDiscard,
              child: Text(
                cancelText ?? discardText,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                confirmText ?? saveText,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    ),
    barrierDismissible: barrierDismissible,
  );
}
