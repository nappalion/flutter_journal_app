import 'package:flutter/material.dart';

import "../widgets/auth_layout.dart";
import "../widgets/login_form.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthLayout(
      title: "Welcome back",
      subtitle: "Log in to keep writing — your entries are waiting.",
      form: LoginForm(),
    );
  }
}
