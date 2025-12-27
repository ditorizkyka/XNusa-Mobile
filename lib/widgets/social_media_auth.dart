import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/auth/controllers/auth_controller.dart';

class SocialMediaOptionAuth extends StatelessWidget {
  const SocialMediaOptionAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.put(AuthController());

    Widget socialBtn({required VoidCallback onTap, required String assetPath}) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          width: 80,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Image.asset(
              assetPath,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        socialBtn(
          onTap: () => authC.signInWithX(),
          assetPath:
              'assets/logo/social-media/twitter.png', // pastiin ada file ini
        ),
        const SizedBox(width: 16),
        socialBtn(
          onTap: () => authC.signInWithGoogle(),
          assetPath: 'assets/logo/social-media/google.png',
        ),
        const SizedBox(width: 16),
        socialBtn(
          onTap: () => authC.signInWithMicrosoft(),
          assetPath: 'assets/logo/social-media/microsoft.png',
        ),
      ],
    );
  }
}
