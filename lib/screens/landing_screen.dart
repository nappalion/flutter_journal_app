import 'package:flutter/material.dart';

import "signup_screen.dart";

import "main_screen.dart";

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                "Journaling Simplified 🌸",
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
              child: Text("Create an account to start journaling"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false, // removes ALL previous routes
                );
              },
              child: Text("Skip for now"),
            ),
            Image.asset('assets/images/landing_image.png'),
          ],
        ),
      ),
    );
  }
}
