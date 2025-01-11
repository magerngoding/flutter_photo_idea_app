// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_photo_idea_app/core/di.dart';
import 'package:flutter_photo_idea_app/presentation/pages/dashboard_page.dart';
import 'package:flutter_photo_idea_app/presentation/pages/search_photos_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'presentation/pages/detail_photo_page.dart';

void main() {
  initInjection();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: DashboardPage(),
      routes: {
        '/home': (context) => DashboardPage(),
        SearchPhotosPage.routeName: (context) {
          final query = ModalRoute.of(context)?.settings.arguments as String;

          return SearchPhotosPage(query: query);
        },
        DetailPhotoPage.routeName: (context) {
          final id = ModalRoute.of(context)?.settings.arguments as int;

          return DetailPhotoPage(id: id);
        }
      },
    );
  }
}
