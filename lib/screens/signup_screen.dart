import 'package:flutter/material.dart';

import "../widgets/signup_form.dart";

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Create an account!", style: TextStyle(fontSize: 16.0)),
            SignupForm(),
            // Add signup form widgets here
          ],
        ),
      ),
    );
  }
}
