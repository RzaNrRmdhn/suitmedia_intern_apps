import 'package:flutter/material.dart';
import 'package:intern_apps/screens/first_screen.dart';
import 'package:intern_apps/screens/second_screen.dart';
import 'package:intern_apps/screens/third_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intern Apps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstScreen(),
        '/SecondScreen': (context) => SecondScreen(),
        '/ThirdScreen': (context) => ThirdScreen(
            name: ModalRoute.of(context)?.settings.arguments as String),
      },
    );
  }
}
