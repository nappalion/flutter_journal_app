import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email = "";
  String password = "";
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (errorMessage.isNotEmpty)
            Text("Error: $errorMessage", style: TextStyle(color: Colors.red)),
          TextField(
            decoration: InputDecoration(labelText: "Email"),
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                errorMessage = "";
              });

              if (email.isEmpty || password.isEmpty) {
                setState(() {
                  errorMessage = "Please fill in all fields.";
                });
                return;
              }

              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                // Was a bug here because StreamBuilder swapped landing with main screen, but
                // this screen was pushed on top of the main screen, so popping it off would
                // reveal the landing (now main) screen.
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              } on FirebaseAuthException catch (e) {
                setState(() {
                  errorMessage = "Invalid email or password";
                });
              } catch (e) {
                setState(() {
                  errorMessage = "Something went wrong. Please try again.";
                });
              }
            },
            child: Text("Log in"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignupScreen()),
              );
            },
            child: Text("Don't have an account? Sign Up"),
          ),
        ],
      ),
    );
  }
}
