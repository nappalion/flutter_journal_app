import 'package:flutter/material.dart';

import '../screens/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(decoration: InputDecoration(labelText: "Email")),
        TextField(
          decoration: InputDecoration(labelText: "Password"),
          obscureText: true,
        ),
        ElevatedButton(onPressed: () {}, child: Text("Sign Up")),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignupScreen()),
            );
          },
          child: Text("Already have an account? Log In"),
        ),
      ],
    );
  }
}
