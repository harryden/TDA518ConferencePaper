import 'package:get/get.dart';

import '../auth_service.dart';


class AuthController extends GetxController {
  var authService = AuthService();
  // Observable variables to hold authentication state
  var isLoggedIn = false.obs;
  var isLoading = false.obs;

  var error = Rxn<dynamic>();

  Future<void> login(String email, String password) async {
    error.value = null;
    isLoading.value = true;
    try {
      error.value = null;
      isLoggedIn.value = true;
      isLoading.value = false;
    } catch (e) {
      error.value = e;
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    error.value = null;
    isLoading.value = true;
    try {
      await authService.logout();
      error.value = null;
      isLoggedIn.value = false;
      isLoading.value = false;
    } catch (e) {
      error.value = e;
      isLoading.value = false;
    }
  }
}
