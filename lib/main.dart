// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_photo_idea_app/presentation/pages/fragment/dashboard_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
      routes: {
        '/home': (context) => DashboardPage(),
      },
    );
  }
}
