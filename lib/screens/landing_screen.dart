import 'package:flutter/material.dart';
import "package:flutter_journal_app/screens/login_screen.dart";
import "package:flutter_journal_app/widgets/auth_layout.dart";

import "signup_screen.dart";

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.paper,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/landing_image.png',
              fit: BoxFit.contain,
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🌸', style: TextStyle(fontSize: 28)),
                    const SizedBox(height: 12),
                    const Text(
                      "Journaling simplified",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AuthColors.ink,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "A quiet place for whatever is on your mind.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AuthColors.muted,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AuthPrimaryButton(
                      label: "Create an account",
                      isLoading: false,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
