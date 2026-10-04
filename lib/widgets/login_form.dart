import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/signup_screen.dart';
import 'auth_layout.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email = "";
  String password = "";
  String errorMessage = "";
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      errorMessage = "";
    });

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Please fill in all fields.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Was a bug here because StreamBuilder swapped landing with main screen, but
      // this screen was pushed on top of the main screen, so popping it off would
      // reveal the landing (now main) screen.
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException {
      setState(() {
        errorMessage = "Invalid email or password";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Something went wrong. Please try again.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (errorMessage.isNotEmpty) ...[
          AuthErrorBanner(message: errorMessage),
          const SizedBox(height: 16),
        ],
        TextField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          autofillHints: const [AutofillHints.email],
          decoration: authInputDecoration(
            label: "Email",
            icon: Icons.mail_outline,
          ),
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
        ),
        const SizedBox(height: 14),
        TextField(
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          onSubmitted: (_) => _submit(),
          decoration: authInputDecoration(
            label: "Password",
            icon: Icons.lock_outline,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AuthColors.muted,
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
        ),
        const SizedBox(height: 24),
        AuthPrimaryButton(
          label: "Log in",
          isLoading: _isLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
          child: Text.rich(
            TextSpan(
              text: "Don't have an account? ",
              style: const TextStyle(color: AuthColors.muted),
              children: [
                TextSpan(
                  text: "Sign up",
                  style: const TextStyle(
                    color: AuthColors.sage,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
