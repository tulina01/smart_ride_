import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/auth_state_changes.dart';
import '../utils/global.colors.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Get.to(const AuthChanges());
    });
    return Scaffold(
      backgroundColor: GlobalColor.mainColor,
      body: const Center(
        child: Text(
          'SMART RIDE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'ATTACK',
          ),
        ),
      ),
    );
  }
}
