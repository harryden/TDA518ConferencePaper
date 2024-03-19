import 'package:conference_paper/auth_service.dart';
import 'package:conference_paper/auth_user.dart';
import 'package:riverpod/riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Define a state notifier for managing authentication state
class AuthStateNotifier extends StateNotifier<AuthenticationState> {
  final Ref ref;
  AuthStateNotifier(this.ref) : super(AuthenticationInitial());

  Future<void> login(String email, String password) async {
    state = AuthenticationLoading();
    try {
      final authUser = await ref.read(authServiceProvider).login(email, password);
      state = AuthenticationLoggedIn(authUser);
    } on Exception catch (e) {
      state = AuthenticationError(e.toString());
    }
  }

  Future<void> logout() async {
    state = AuthenticationLoading();
    try {
      ref.read(authServiceProvider).logout();
      state = AuthenticationLoggedOut();
    } on Exception catch (e) {
      state = AuthenticationError(e.toString());
    }
  }
}

// Define a provider for the AuthStateNotifier
final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AuthenticationState>((ref) {
  return AuthStateNotifier(ref);
});

// Define the states
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String error;
  AuthenticationError(this.error);
}

class AuthenticationLoggedIn extends AuthenticationState {
  final AuthUser authUser;
  AuthenticationLoggedIn(this.authUser);
}

class AuthenticationLoggedOut extends AuthenticationState {}
