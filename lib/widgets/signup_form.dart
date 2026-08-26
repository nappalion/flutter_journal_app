import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
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
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: Text("Already have an account? Log In"),
        ),
      ],
    );
  }
}
