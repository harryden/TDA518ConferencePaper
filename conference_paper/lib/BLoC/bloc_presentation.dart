import 'package:conference_paper/BLoC/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Authentication',
      home: BlocProvider(
        create: (context) => AuthBloc(),
        child: AuthenticationScreen(),
      ),
    );
  }
}

void showErrorDialog(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close the dialog
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}

class AuthenticationScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BLoC Auth')),
      body: Center(
        child: BlocConsumer<AuthBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationError) {
              showErrorDialog(state.error.toString(), context);
            }
          },
          builder: (context, state) {
            if (state is AuthenticationLoading) {
              return CircularProgressIndicator();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          AuthenticationLogin(
                            emailController.text,
                            passwordController.text,
                          ),
                        );
                  },
                  child: Text("Login"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
