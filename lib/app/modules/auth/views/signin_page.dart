import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import 'package:xnusa_mobile/widgets/input_field.dart';
import 'package:xnusa_mobile/widgets/social_media_auth.dart';

import '../controllers/auth_controller.dart';

class SigninPage extends GetView<AuthController> {
  final AuthController c = Get.find();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(SizeApp.w20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    (SizeApp.w20 * 2),
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.h32,
                    Image.asset(
                      'assets/logo/square-xn.png',
                      height: 80,
                      width: 80,
                    ),
                    Gap.h24,
                    Text("Sign In", style: TypographyApp.headline1),
                    Gap.h32,

                    InputField(
                      labelInput: "Email",
                      hintInput: "rhenofebrian@gmail.com",
                      isPassword: false,
                      controller: emailC,
                    ),

                    Gap.h8,
                    InputField(
                      labelInput: "Password",
                      hintInput: "*******",
                      isPassword: true,
                      controller: passC,
                    ),

                    Gap.h4,
                    GestureDetector(
                      onTap: () {
                        print("Forgot Password");
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TypographyApp.label.copyWith(
                          color: ColorApp.primary,
                        ),
                      ),
                    ),

                    Gap.h16,
                    Obx(
                      () =>
                          c.isLoading.value
                              ? Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: SizeApp.h12,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ColorApp.primary,
                                  borderRadius: BorderRadius.circular(
                                    SizeApp.h8,
                                  ),
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              )
                              : GestureDetector(
                                onTap: () => c.signIn(emailC.text, passC.text),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: SizeApp.h12,
                                  ),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ColorApp.primary,
                                    borderRadius: BorderRadius.circular(
                                      SizeApp.h8,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Sign In",
                                      style: TypographyApp.textLight,
                                    ),
                                  ),
                                ),
                              ),
                    ),
                    Gap.h24,
                    // Garis dan teks "Or Login with"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Or Login with",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              color: ColorApp.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Tombol social media
                    SocialMediaOptionAuth(),

                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TypographyApp.label,
                        ),
                        GestureDetector(
                          onTap: () => Get.offNamed('/signup'),
                          child: Text(
                            "Sign Up",
                            style: TypographyApp.label.copyWith(
                              color: ColorApp.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
