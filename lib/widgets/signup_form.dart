import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  String email = "";
  String password = "";
  String username = "";
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
            decoration: InputDecoration(labelText: "Username"),
            onChanged: (value) {
              setState(() {
                username = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: "Password"),
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                errorMessage = "";
              });

              if (email.isEmpty || password.isEmpty || username.isEmpty) {
                setState(() {
                  errorMessage = "Please fill in all fields.";
                });
                return;
              }

              try {
                UserCredential credential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  setState(() {
                    errorMessage = 'The password provided is too weak.';
                  });
                } else if (e.code == 'email-already-in-use') {
                  setState(() {
                    errorMessage = 'The account already exists for that email.';
                  });
                }
              } catch (e) {
                setState(() {
                  errorMessage = 'An error occurred. Please try again.';
                });
              }
            },
            child: Text("Sign Up"),
          ),
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
      ),
    );
  }
}
