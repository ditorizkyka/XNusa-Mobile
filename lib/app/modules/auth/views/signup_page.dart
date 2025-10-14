import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class SignupPage extends GetView<AuthController> {
  final AuthController c = Get.find();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final phoneC = TextEditingController();

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AuthView'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailC,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passC,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              TextField(
                controller: phoneC,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 20),
              Obx(
                () =>
                    c.isLoading.value
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: () => c.signUp(emailC.text, passC.text),
                          child: Text('Register'),
                        ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
