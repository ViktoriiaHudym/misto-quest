import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'theme/app_theme.dart';
import 'package:mistoquest_frontend/screens/home_screen.dart';
// import 'screens/challenge_list_screen.dart';
import 'package:mistoquest_frontend/screens/welcome_screen.dart';
import 'package:mistoquest_frontend/screens/login_screen.dart';
import 'package:mistoquest_frontend/screens/register_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MistoQuest',
      theme: appTheme(),
      initialRoute: WelcomeScreen.routeName,

      routes: {
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        // Navigate to HomeScreen after a successful login
        HomeScreen.routeName: (context) => HomeScreen(),
      },
    );
  }
}
