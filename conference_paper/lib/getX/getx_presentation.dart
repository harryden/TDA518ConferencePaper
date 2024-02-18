import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

void main() {
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Authentication',
      home: AuthenticationScreen(),
    );
  }
}

void showErrorDialog(String message) {
  Get.dialog(
    AlertDialog(
      title: const Text("Error"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: const Text("OK"),
        ),
      ],
    ),
    barrierDismissible: false, // User must tap a button to close the dialog
  );
}


class AuthenticationScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GetX Auth')),
      body: Center(
        child: Obx(() {
          if (authController.error.value != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showErrorDialog(authController.error.value.toString());
            });
          }
          if (authController.isLoading.value) {
            return const CircularProgressIndicator();
          }
          // Logged In State
          else if (authController.isLoggedIn.value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Welcome! You are logged in."),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => authController.logout(),
                  child: const Text("Logout"),
                ),
              ],
            );
          }
          // Logged Out State (default)
          else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => authController.login(
                      emailController.text, passwordController.text),
                  child: const Text("Login"),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  void showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              authController.error.value = null; // Clear the error
              Get.back(); // Close the dialog
            },
            child: const Text("OK"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
