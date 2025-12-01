import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xnusa_mobile/app/modules/auth/views/signin_page.dart';
import 'package:xnusa_mobile/constant/constant.dart';
import 'package:xnusa_mobile/widgets/button_app_filled_expanded.dart';
import 'package:xnusa_mobile/widgets/input_field.dart';
import '../controllers/auth_controller.dart';

class SignupPage extends GetView<AuthController> {
  SignupPage({super.key});

  // Controller text field
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmPassC = TextEditingController();
  final usernameC = TextEditingController();
  final displayNameC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthController>();

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
                    Text("Sign Up", style: TypographyApp.headline1),
                    Gap.h32,

                    InputField(
                      labelInput: "Email",
                      hintInput: "rhenofebrian@gmail.com",
                      isPassword: false,
                      controller: emailC,
                    ),

                    Gap.h8,
                    InputField(
                      labelInput: "Create Password",
                      hintInput: "must be at least 8 characters",
                      isPassword: true,
                      controller: passC,
                    ),
                    Gap.h8,
                    InputField(
                      labelInput: "Confirm Password",
                      hintInput: "repeat your password",
                      isPassword: true,
                      controller: confirmPassC,
                    ),
                    Gap.h8,
                    InputField(
                      labelInput: "Username",
                      hintInput: "create an unique username!",
                      isPassword: false,
                      controller: usernameC,
                    ),
                    Gap.h8,
                    InputField(
                      labelInput: "Display Name",
                      hintInput: "your full name",
                      isPassword: false,
                      controller: displayNameC,
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
                              : ButtonAppFilledExpanded(
                                onTap: () async {
                                  final email = emailC.text.trim();
                                  final pass = passC.text.trim();
                                  final username = usernameC.text.trim();
                                  final displayName = displayNameC.text.trim();

                                  if (email.isEmpty ||
                                      pass.isEmpty ||
                                      username.isEmpty ||
                                      displayName.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Please fill in all fields',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    return;
                                  }

                                  if (pass != confirmPassC.text.trim()) {
                                    Get.snackbar(
                                      'Error',
                                      'Passwords do not match',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    return;
                                  }

                                  await c.signUp(
                                    email: email,
                                    password: pass,
                                    displayName: displayName,
                                    username: username,
                                  );
                                },
                                title: "Sign Up",
                              ),
                    ),

                    Gap.h24,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TypographyApp.label,
                        ),
                        GestureDetector(
                          onTap: () => Get.offNamed('/signin'),
                          child: Text(
                            "Sign In",
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
