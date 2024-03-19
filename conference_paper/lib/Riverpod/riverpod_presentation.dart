import 'package:conference_paper/Riverpod/auth_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Authentication',
      home: AuthenticationScreen(),
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

class AuthenticationScreen extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Riverpod Auth')),
      body: Center(
        child: Builder(
          builder: (BuildContext context) {
             WidgetsBinding.instance.addPostFrameCallback((_) {
                if (state is AuthenticationError) {
                  showErrorDialog(state.error.toString(), context);
                }
              }); 

              if (state is AuthenticationLoading) {
                return CircularProgressIndicator();
              } else if (state is AuthenticationLoggedIn) {
                 return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Welcome! You are logged in."),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => ref.read(authStateNotifierProvider.notifier).logout(),
                        child: const Text("Logout"),
                      ),
                    ],
                  );
              } else {
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
                        ref.read(authStateNotifierProvider.notifier).login(emailController.text, passwordController.text);
                      },
                      child: Text("Login"),
                    ),
                  ],
                );
              }
          },
        ),
      ),
    );
  }
}

