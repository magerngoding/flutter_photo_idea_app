// ignore_for_file: prefer_const_constructors

import 'package:d_session/d_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_photo_idea_app/core/di.dart';
import 'package:flutter_photo_idea_app/presentation/pages/dashboard_page.dart';
import 'package:flutter_photo_idea_app/presentation/pages/onboarding_page.dart';
import 'package:flutter_photo_idea_app/presentation/pages/search_photos_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'presentation/pages/detail_photo_page.dart';

void main() async {
  // asynchronous
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(Duration(milliseconds: 1000), () {
    FlutterNativeSplash.remove();
  });
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
      routes: {
        '/': (context) => FutureBuilder(
              future: DSession.getCustom('see-onboarding'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) return OnBoardingPage();
                  return DashboardPage();
                }
                return SizedBox();
              },
            ),
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
