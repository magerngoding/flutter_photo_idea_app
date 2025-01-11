// ignore_for_file: prefer_const_constructors

import 'package:blur/blur.dart';
import 'package:d_session/d_session.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../common/app_constant.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  void gotoDashboard() {
    DSession.setCustom('see-onboarding', true).then((value) {
      if (mounted) Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        // full layar stackfitexpand
        fit: StackFit.expand,
        children: [
          // Agar full layar gambar nya pake .fill
          Positioned.fill(
            child: Image.asset(
              AppConstant.onBoardingBackground,
              fit: BoxFit.cover,
              height: size.height,
            ).blurred(
              blurColor: Colors.black,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppConstant.onBoardingImage,
                width: size.width * 0.8,
                height: size.width * 1,
              ),
              Gap(50),
              Text(
                "Wellcome ti P-Idea",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Gap(8),
              Text(
                "Explore your Idea\nand discover word class quality!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.white70,
                ),
              ),
              Gap(24),
              OutlinedButton(
                onPressed: gotoDashboard,
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  side: WidgetStatePropertyAll(
                    BorderSide(color: Colors.white54),
                  ),
                ),
                child: Text(
                  'Begin',
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
