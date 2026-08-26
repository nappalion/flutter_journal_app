import 'package:flutter/material.dart';

import "../widgets/login_form.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log In')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome back!", style: TextStyle(fontSize: 16.0)),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
