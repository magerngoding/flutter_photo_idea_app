import 'package:flutter/material.dart';
import 'package:flutter_photo_idea_app/common/app_constant.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Image.asset(
            AppConstant.onBoardingImage,
            width: 120.0,
            height: 120.0,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
