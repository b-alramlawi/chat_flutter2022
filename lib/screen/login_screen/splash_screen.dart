import 'dart:async';
import 'package:chat_flutter2022/screen/login_screen/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth _auth;
  User _user;
  bool isLoading = true;

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => isLoading
                ? const WelcomeScreen()
                : _user == null
                    ? const WelcomeScreen()
                    : const HomeScreen()),
        (route) => false,
      );
    });
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 50,
        ),
        child: Center(
          child: Container(
            width: 120.0,
            height: 120.0,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/chatLogo.png'), fit: BoxFit.fill),
            ),
          ),
        ),
      ),
    );
  }
}
