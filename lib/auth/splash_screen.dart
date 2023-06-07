import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_medcare/auth/splash_services.dart';
import '../utils/decoration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      splashServices.isLogin(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Image.asset("assets/images/splash.jpg"),
          ])),
    );
  }
}
