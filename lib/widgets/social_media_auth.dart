import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:xnusa_mobile/app/modules/auth/controllers/auth_controller.dart';

class SocialMediaOptionAuth extends StatelessWidget {
  const SocialMediaOptionAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.put(AuthController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            print("Login with Facebook");
          },
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
              child: Icon(
                FontAwesomeIcons.facebookF,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),
        InkWell(
          onTap: () => authC.signInWithGoogle(),
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
              child: Icon(FontAwesomeIcons.google, color: Colors.red, size: 20),
            ),
          ),
        ),

        const SizedBox(width: 16),
        InkWell(
          onTap: () {
            print("Login with Apple");
          },
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
              child: Icon(
                FontAwesomeIcons.apple,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
