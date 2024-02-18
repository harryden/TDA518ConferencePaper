import 'package:conference_paper/auth_user.dart';

class AuthService {
  Future<AuthUser> login(String email, String password) async {
    // check that the email is valid format and that the password is not empty
    if (!email.contains('@') || password.isEmpty) {
      throw Exception('Invalid email or password');
    }
    Future.delayed(Duration(seconds: 2));
    return AuthUser(uid: "123", email: email);
  }

  Future<void> logout() async {
    return Future.delayed(Duration(seconds: 1));
  }
}
