import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/user_participation_screen.dart';


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
      home: HomeScreen(),

      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        UserParticipationScreen.routeName: (context) => UserParticipationScreen(),
      },

    );
  }
}
