import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class SignupPage extends GetView<AuthController> {
  SignupPage({super.key});

  // Controller text field
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final usernameC = TextEditingController();
  final displayNameC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                "Create Your Account",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),

              // Username
              TextField(
                controller: usernameC,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),

              // Display name
              TextField(
                controller: displayNameC,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 12),

              // Email
              TextField(
                controller: emailC,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 12),

              // Password
              TextField(
                controller: passC,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),

              // Register button
              Obx(
                () =>
                    c.isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
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
                                  'Semua field harus diisi',
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
                            child: const Text('Register'),
                          ),
                        ),
              ),
              const SizedBox(height: 12),

              // Back to login
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
