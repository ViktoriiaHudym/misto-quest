import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';


class WelcomeScreen extends StatelessWidget {
  static const String routeName = '/'; // Route for the initial screen

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to MistoQuest'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the Login screen
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Register screen
                Navigator.pushNamed(context, RegisterScreen.routeName);
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}