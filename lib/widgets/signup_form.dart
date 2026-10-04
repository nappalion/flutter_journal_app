import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'auth_layout.dart';
import 'emoji_picker.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final db = FirebaseFirestore.instance;
  String email = "";
  String password = "";
  String username = "";
  String errorMessage = "";
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _emoji = ProfileEmoji.fallback;

  Future<void> _submit() async {
    setState(() {
      errorMessage = "";
    });

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      setState(() {
        errorMessage = "Please fill in all fields.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

      final user = credential.user;
      if (user == null) {
        setState(() {
          errorMessage = "Failed to create account.";
          _isLoading = false;
        });
        return;
      }
      await db.collection("users").doc(user.uid).set({
        "username": username,
        ProfileEmoji.field: _emoji,
        "createdAt": FieldValue.serverTimestamp(),
      });

      // Same StreamBuilder issue
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          errorMessage = 'The password provided is too weak.';
          _isLoading = false;
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          errorMessage = 'The account already exists for that email.';
          _isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'An error occurred. Please try again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred. Please try again.';
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
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.username],
          decoration: authInputDecoration(
            label: "Username",
            icon: Icons.person_outline,
          ),
          onChanged: (value) {
            setState(() {
              username = value;
            });
          },
        ),
        const SizedBox(height: 14),
        EmojiField(
          emoji: _emoji,
          enabled: !_isLoading,
          onChanged: (value) {
            setState(() {
              _emoji = value;
            });
          },
        ),
        const SizedBox(height: 14),
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
          autofillHints: const [AutofillHints.newPassword],
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
          label: "Create account",
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
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
          child: Text.rich(
            TextSpan(
              text: "Already have an account? ",
              style: const TextStyle(color: AuthColors.muted),
              children: [
                TextSpan(
                  text: "Log in",
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
