import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/constant/constant.dart';

class InputField extends StatelessWidget {
  final String labelInput;
  final String hintInput;
  final bool isPassword;
  final TextEditingController? controller;

  // Reactive variable untuk password visibility & email validation
  final RxBool isPasswordVisible = false.obs;
  final RxBool isValidEmail = false.obs;

  InputField({
    required this.isPassword,
    this.controller,
    required this.labelInput,
    required this.hintInput,
    super.key,
  });

  bool _validateEmail(String value) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(pattern).hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelInput, style: TypographyApp.label),
        SizedBox(height: SizeApp.h8),

        Obx(
          () => TextField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible.value,
            onChanged: (value) {
              if (!isPassword) {
                isValidEmail.value = _validateEmail(value);
              }
            },
            decoration: InputDecoration(
              hintText: hintInput,
              hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),

              suffixIcon:
                  isPassword
                      ? IconButton(
                        onPressed: () {
                          isPasswordVisible.value = !isPasswordVisible.value;
                        },
                        icon: Icon(
                          isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey.shade700,
                          size: 20,
                        ),
                      )
                      : (isValidEmail.value
                          ? Container(
                            margin: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15,
                            ),
                          )
                          : null),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
          ),
        ),
        SizedBox(height: SizeApp.h8),
      ],
    );
  }
}
