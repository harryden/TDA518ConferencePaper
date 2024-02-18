import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

void main() {
  // Step 2: Initialize the AuthController
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      title: Text("Error"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: Text("OK"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GetX Auth')),
      body: Center(
        child: Obx(() {
          // If there's an error, show the dialog
          if (authController.error.value != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showErrorDialog(authController.error.value.toString());
            });
          }
      
          // Loading State
          if (authController.isLoading.value) {
            return CircularProgressIndicator();
          }
          // Logged In State
          else if (authController.isLoggedIn.value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Welcome! You are logged in."),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => authController.logout(),
                  child: Text("Logout"),
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
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => authController.login(
                      emailController.text, passwordController.text),
                  child: Text("Login"),
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
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              authController.error.value = null; // Clear the error
              Get.back(); // Close the dialog
            },
            child: Text("OK"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
