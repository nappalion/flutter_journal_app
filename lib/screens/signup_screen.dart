import 'package:flutter/material.dart';

import "../widgets/auth_layout.dart";
import "../widgets/signup_form.dart";

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthLayout(
      title: "Start journaling",
      subtitle: "Create an account to save your thoughts in one quiet place.",
      form: SignupForm(),
    );
  }
}
