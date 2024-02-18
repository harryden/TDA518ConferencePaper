import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_service.dart';
import '../auth_user.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthBloc() : super(AuthenticationInitial()) {
    AuthService provider = AuthService();

    on<AuthenticationLogin>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        final authUser = await provider.login(event.email, event.password);
        emit(AuthenticationLoggedIn(authUser));
      } on Exception catch (e) {
        emit(AuthenticationError(e));
      }
    });

    on<AuthenticationLogout>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        provider.logout();
      } on Exception catch (e) {
        emit(AuthenticationError(e));
      }
    });
  }
}

@immutable
abstract class AuthenticationEvent {}

class AuthenticationLogin extends AuthenticationEvent {
  final String email;
  final String password;

  AuthenticationLogin(this.email, this.password);
}

class AuthenticationLogout extends AuthenticationEvent {}

@immutable
class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final Exception error;
  AuthenticationError(this.error);
}

class AuthenticationLoggedIn extends AuthenticationState {
  final AuthUser authUser;
  AuthenticationLoggedIn(this.authUser);
}

class AuthenticationLoggedOut extends AuthenticationState {
  AuthenticationLoggedOut();
}
