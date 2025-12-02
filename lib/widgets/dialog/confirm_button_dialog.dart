import 'package:flutter/material.dart';
import 'package:xnusa_mobile/constant/constant.dart';

class ConfirmButtonDialog extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onConfirm;

  const ConfirmButtonDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onConfirm,
    this.buttonText = "Done",
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
        Center(
          child: ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.only(bottom: 16),
    );
  }
}
